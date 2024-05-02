# frozen_string_literal: true

module CounselorDashboards
  class DaAppResultCard < CounselorBase
    attr_reader :app_type

    def initialize(params, current_user)
      @app_type = params[:app_type]
      super(params, current_user)
    end


    def call
      {
        explore_key(:result_accepted_conditional) => dpa_students.where(result: DirectProgramApplication.results['result_accepted_conditional']).count,
        explore_key(:result_accepted) => dpa_students.where(result: DirectProgramApplication.results['result_accepted']).count,
        explore_key(:result_pending) => dpa_students.where(result: DirectProgramApplication.results['result_pending']).count,
        explore_key(:result_submitted) => dpa_students.where(result: DirectProgramApplication.results['result_submitted']).count,
        explore_key(:result_denied) => dpa_students.where(result: DirectProgramApplication.results['result_denied']).count,
        explore_key(:result_withdrawn) => dpa_students.where(result: DirectProgramApplication.results['result_withdrawn']).count,
        explore_key(:result_deferred) => dpa_students.where(result: DirectProgramApplication.results['result_deferred']).count,
        explore_key(:result_not_interested) => dpa_students.where(result: DirectProgramApplication.results['result_not_interested']).count,
        explore_key(:result_waitlisted) => dpa_students.where(result: DirectProgramApplication.results['result_waitlisted']).count,
        explore_key(:result_conditional_offer) => dpa_students.where(result: DirectProgramApplication.results['result_conditional_offer']).count,
        explore_key(:result_unconditional_offer) => dpa_students.where(result: DirectProgramApplication.results['result_unconditional_offer']).count,
        'no_status' => dpa_students.where(result: DirectProgramApplication.results['no_status']).count
      }
    end

    def explore_key(value)
      key = Constants::DirectProgramApplication::EXPLORE_RESULT_MAPPING.key(value).downcase.tr(' ', '_')
      return 'accepted_unconditional' if key == 'accepted'

      key
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
