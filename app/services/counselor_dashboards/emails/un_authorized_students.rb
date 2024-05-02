# frozen_string_literal: true

module CounselorDashboards
  module Emails
    class UnAuthorizedStudents
      include ActiveJobPerformMixing
      attr_reader :dashboard_user_id, :tenant_id, :current_user_id

      FROM_EMAIL = Rails.env.production? ? 'notifications@cialfo.co' : 'notification@cialfo.com.sg'

      def initialize(dashboard_user_id, current_user_id, tenant_id)
        @dashboard_user_id = dashboard_user_id
        @current_user_id = current_user_id
        @tenant_id = tenant_id
      end

      def call
        switch_tenant
        send_emails
      end

      def job
        active_job_perform(
          'CounselorDashboards::Emails',
          'UnAuthorizedStudentsJob',
          dashboard_user_id,
          current_user_id,
          tenant_id
        )
      end

      private

      def switch_tenant
        tenant.switch
      end

      def current_user
        @current_user ||= User.find(current_user_id)
      end

      def tenant
        @tenant ||= Tenant.find(tenant_id)
      end

      def dashboard_user
        @dashboard_user ||= begin
          return current_user if current_user.mentor? && !current_user.admin?
          User.find_by(id: dashboard_user_id)
        end
      end

      def send_emails
        students.find_each do |student|
          send_email(student.user, dashboard_user)
        end
      end

      def send_email(user, dashboard_user)
        MandrillHelper.send_html_mail(
          user.email_params,
          subject(user),
          email_template(user, dashboard_user),
          {},
          [],
          '',
          FROM_EMAIL
        )
      end

      def email_template(user, dashboard_user)
        ApplicationController.new.render_to_string(
          template: 'emails/da_emails_layout',
          locals: {
            user:                   user,
            current_user:           current_user,
            tenant_url:             tenant_url
          }
        )
      end

      def students
        @students ||= CounselorDashboards::StudentAuthCard.new(params, current_user).unauthenticated_students.includes(:user)
      end

      def params
        { dashboard_user_id: dashboard_user_id }
      end

      def subject(user)
        I18n.t('common.unauthorized_student_email_subject', locale: user.locale)
      end

      def tenant_url
        TenantHelper.get_tenant_url(tenant.sub_domain)
      end
    end
  end
end
