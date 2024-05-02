# frozen_string_literal: true

module CounselorDashboards
  class DaFunnelCard < CounselorBase
    attr_reader :app_type

    def initialize(params, current_user)
      @app_type = params[:app_type]
      super(params, current_user)
    end

    def call
      app_reviewed_statuses = DirectProgramApplication.explore_statuses.slice('submitted_to_cialfo', 'submitted_to_university').values
      app_not_reviewed_statuses = DirectProgramApplication.explore_statuses.slice('submitted_to_counselor', 'revision_required').values
      {
        app_review: {
          'true': dpa_students.submitted.where(is_form_complete: true).where(explore_status: app_reviewed_statuses).count,
          'false': dpa_students.submitted.where(is_form_complete: true).where(explore_status: app_not_reviewed_statuses).count
        },
        submission: {
          'true': dpa_students.submitted.where(is_form_complete: true).where(explore_status: explore_submitted_statuses).count,
          'false': dpa_students.submitted.where(is_form_complete: true).where(explore_status: explore_unsubmitted_statuses).count
        },
        is_form_complete: {
          'false': dpa_students.where(is_form_complete: false).count,
          'true': dpa_students.where(is_form_complete: true).count
        }
      }
    end

    def form_hash
      dpa_students.group('direct_program_applications.is_form_complete').count
    end

    def explore_submitted_statuses
      DirectProgramApplication.explore_statuses.slice('submitted_to_cialfo', 'reviewing', 'submitted_to_university', 'pending_info', 'pending_decision', 'deposit_paid', 'cas_issued', 'visa_processing', 'visa_approved', 'visa_rejected', 'fees_paid', 'deposit_pending').values
    end

    def explore_unsubmitted_statuses
      DirectProgramApplication.explore_statuses.slice('submitted_to_counselor', 'revision_required', 'revision_requested_by_cialfo').values
    end

    def dpa_students
      @dpa_students ||= DirectProgramApplication.where(student_id: students.map(&:user_id)).where(dpa_conditions)
    end

    def dpa_conditions
      return '' if app_type.blank? || app_type == 'all'
      return "direct_apply_program_id IN (#{region_based_dap_ids})" unless app_type.in?(['ucas', 'da'])

      dap_ids = dap_ucas_ids.join(',')
      return "direct_apply_program_id IN (#{dap_ids})" if app_type == 'ucas' && current_tenant.enable_direct_apply_ucas

      "direct_apply_program_id NOT IN (#{dap_ids})"
    end
  end
end
