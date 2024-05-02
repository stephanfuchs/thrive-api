# frozen_string_literal: true

module V5
  class CounselorDashboardController < V5::ApplicationController
    helper CounselorDashboardHelper
    before_action :authorize_user

    def index
      graduation_years = Rails.cache.fetch("graduation_years", expires_in: 1.day) do
        grad_year = Deadline.graduation_year_definition
        grad_year..grad_year+3
      end
      @dashboard_data = {}
      @dashboard_data[:assesments] = CounselorDashboards::AssesmentsCard.new(tenant, graduation_years, mentor_id: dashboard_user_id).call if params[:type] == 'assesments'
      @dashboard_data[:lists] = CounselorDashboards::ListsCard.new(tenant, graduation_years, mentor_id: dashboard_user_id).call if params[:type] == 'lists'
      @dashboard_data[:last_sign_in] = CounselorDashboards::LastLoginCard.new(tenant, graduation_years, 3.months.ago, mentor_id: dashboard_user_id).call if params[:type] == 'last_sign_in'
      @dashboard_data[:unregistered] = CounselorDashboards::UnregisteredCard.new(tenant, graduation_years, mentor_id: dashboard_user_id).call if params[:type] == 'unregistered'
      @dashboard_data[:cialfo_community] = CialfoCommunity.order('created_at desc').select(:post_url, :creator_avatar_link, :creator_first_name, :title, :summary, :updated_at).first(3) if params[:type] == 'cialfo_community'
      @dashboard_data[:student_auth] = CounselorDashboards::StudentAuthCard.new(params, current_user).call if params[:type] == 'student_auth'
      @dashboard_data[:da_funnel] = CounselorDashboards::DaFunnelCard.new(params, current_user).call if params[:type] == 'da_funnel'
      @dashboard_data[:da_app_result] = CounselorDashboards::DaAppResultCard.new(params, current_user).call if params[:type] == 'da_app_result'
      @dashboard_data[:da_docs] = CounselorDashboards::DaDocumentsCard.new(params, current_user).call if params[:type] == 'da_docs'
      @dashboard_data[:common_app_status] = CounselorDashboards::CommonAppStatusCard.new(params, current_user).call if params[:type] == 'common_app_status'
      @dashboard_data[:recommendations_requested] = CounselorDashboards::RecommendationsRequestedCard.new(params, current_user).call if params[:type] == 'recommendations_requested'
      @dashboard_data[:supporting_documents_sent] = CounselorDashboards::SupportingDocumentsSentCard.new(params, current_user).call if params[:type] == 'supporting_documents_sent'
    end

    def assesments_list
      @list_data = CounselorDashboards::AssesmentsList.new(tenant, params[:graduation_year], page: params[:page], completed: params[:completed], assesment_type: params[:assesment_type], order_column: params[:order_column], order_direction: params[:order_direction], mentor_id: dashboard_user_id).call
    end

    def last_sign_in_list
      @list_data = CounselorDashboards::LastLoginList.new(tenant, params[:graduation_year], 3.months.ago, signed_in: params[:signed_in], page: params[:page], order_column: params[:order_column], order_direction: params[:order_direction], mentor_id: dashboard_user_id).call
    end

    def lists_list
      @list_data = CounselorDashboards::ListsList.new(tenant, params[:graduation_year], page: params[:page], in_list: params[:in_list], list_type: params[:list_type], order_column: params[:order_column], order_direction: params[:order_direction], mentor_id: dashboard_user_id).call
    end

    def unregistered_list
      @list_data = CounselorDashboards::UnregisteredList.new(tenant, params[:graduation_year], registered: params[:registered], page: params[:page], order_column: params[:order_column], order_direction: params[:order_direction], mentor_id: dashboard_user_id).call
    end

    def student_auth_list
      service = CounselorDashboards::StudentAuthList.new(params, current_user)
      @students = service.call
      @total_count = service.total_count
    end

    def da_funnel_list
      da_funnel_list = CounselorDashboards::DaFunnelList.new(params, current_user)

      @direct_program_applications = da_funnel_list.call
      @total_count = da_funnel_list.total_count
      @direct_apply_programs_hash = da_funnel_list.direct_apply_programs_hash
    end

    def da_app_result_list
      da_app_result_list = CounselorDashboards::DaAppResultList.new(params, current_user)

      @direct_program_applications = da_app_result_list.call
      @total_count = da_app_result_list.total_count
      @direct_apply_programs_hash = da_app_result_list.direct_apply_programs_hash
    end

    def da_documents_list
      da_documents_list = CounselorDashboards::DaDocumentsList.new(params, current_user)

      @direct_program_applications = da_documents_list.call
      @total_count = da_documents_list.total_count
      @direct_apply_programs_hash = da_documents_list.direct_apply_programs_hash
    end

    def common_app_status_list
      common_app_linked_list = CounselorDashboards::CommonAppStatusList.new(params, current_user)

      @students = common_app_linked_list.call
      @applying_to_ca_student_ids = common_app_linked_list.applying_to_ca_student_ids
      @total_count = common_app_linked_list.total_count
    end

    def recommendations_requested_list
      recommendations_requested_list = CounselorDashboards::RecommendationsRequestedList.new(params, current_user)

      @recommendations_requested_list = recommendations_requested_list.call
      @recommendations_required_count_hash = recommendations_requested_list.recommendations_required_count_hash
      @total_count = recommendations_requested_list.total_count
    end

    def unauthorized_student_reminder
      CounselorDashboards::Emails::UnAuthorizedStudents.new(params[:dashboard_user_id], current_user.id, tenant.id).job

      head :ok
    end

    def supporting_documents_sent_list
      list_data = CounselorDashboards::SupportingDocumentsSentList.new(params, current_user)

      @list_data = list_data.call
      @total_count = list_data.total_count
      @no_of_applications_hash = list_data.no_of_applications_hash
    end

    private

    def dashboard_user_id
      current_user.admin? ? params[:dashboard_user_id].presence : current_user.id
    end

    def authorize_user
      authorize :counselor_dashboard, :index?
    end
  end
end
