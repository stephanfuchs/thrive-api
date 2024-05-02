# frozen_string_literal: true

module CounselorDashboards
  class DaAppResultList < CounselorBase
    attr_reader :params, :result, :page, :per_page, :order_column, :order_direction, :search_keyword, :app_type

    def initialize(params, current_user)
      @params = params
      @result = params[:result]
      @page = params[:page]
      @per_page = 20
      @order_column = params[:order_column] || 'last_name'
      @order_direction = params[:order_direction] || 'asc'
      @search_keyword = CGI.unescape(params['search_keyword'] || '').scrub
      @app_type = params[:app_type]
      super(params, current_user)
    end

    def call
      final_query
    end

    def total_count
      final_query.total_entries
    end

    def direct_apply_programs_hash
      @direct_apply_programs_hash ||= DirectApplyProgram.joins('LEFT JOIN schools on direct_apply_programs.school_id = schools.id')
                                                        .where(dap_conditions)
                                                        .select(direct_apply_program_select).map { |dap| [dap.id, dap] }.to_h
    end

    private

    def final_query
      @final_query ||= base_query.order(order).paginate(page: page, per_page: per_page)
    end

    def base_query
      @base_query ||= direct_program_applications
    end

    def direct_program_applications
      @direct_program_applications ||= DirectProgramApplication.joins(student: :user).where(dpa_conditions)
                                                               .where(where_clause).merge(User.search(search_keyword))
                                                               .select(direct_program_application_select)
    end

    def where_clause
      clause = { student_id: students.map(&:user_id) }
      clause = clause.merge(direct_program_applications: { result: result_statuses }) if result.present?

      clause
    end

    def dpa_conditions
      return '' if app_type.blank? || app_type == 'all'
      return "direct_apply_program_id IN (#{region_based_dap_ids})" unless app_type.in?(['ucas', 'da'])

      dap_ids = dap_ucas_ids.join(',')
      return "direct_apply_program_id IN (#{dap_ids})" if app_type == 'ucas' && current_tenant.enable_direct_apply_ucas

      "direct_apply_program_id NOT IN (#{dap_ids})"
    end

    def dap_conditions
      conditions = { id: final_query.map(&:direct_apply_program_id) }
      return conditions if app_type.blank? || app_type == 'all' || ['ucas', 'da'].exclude?(app_type)

      conditions = conditions.merge(is_ucas: (app_type == 'ucas' && current_tenant.enable_direct_apply_ucas))
      conditions
    end

    def result_statuses
      return DirectProgramApplication.results.slice('result_accepted', 'result_accepted_conditional').values if result == 'accepted'
      return DirectProgramApplication.results.slice('result_pending', 'result_submitted', 'result_denied', 'result_withdrawn', 'result_deferred', 'result_not_interested').values if result == 'other'
      return DirectProgramApplication.results.slice('result_waitlisted').values if result == 'waitlisted'
      return DirectProgramApplication.results.slice('result_conditional_offer', 'result_unconditional_offer').values if result == 'offer'

      [nil] if result == 'no_status'
    end


    def direct_program_application_select
      "direct_program_applications.direct_apply_program_id, direct_program_applications.result, CONCAT(users.first_name, ' ', users.last_name) as f_name, students.user_id as student_id"
    end

    def direct_apply_program_select
      'direct_apply_programs.id as id, schools.image_logo, schools.name'
    end

    def order
      {
        'accepted asc' => 'FIELD(direct_program_applications.result, 9, 10)',
        'accepted desc' => 'FIELD(direct_program_applications.result, 10, 9)',
        'student_name asc' => 'users.last_name asc',
        'student_name desc' => 'users.last_name desc',
      }.dig("#{order_column} #{order_direction}")
    end
  end
end
