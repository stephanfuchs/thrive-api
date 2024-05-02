# frozen_string_literal: true

module CounselorDashboards
  class DaFunnelList < CounselorBase
    attr_reader :params, :col_type, :col_type_value, :page, :per_page, :order_column, :order_direction, :app_type, :search_keyword

    def initialize(params, current_user)
      @params = params
      @col_type = params['column_type']
      @col_type_value = params.key?('value') ? YAML.safe_load(params['value'].to_s) : true
      @page = params[:page]
      @per_page = 20
      @order_column = params[:order_column] || 'last_name'
      @order_direction = params[:order_direction] || 'asc'
      @app_type = params[:app_type]
      @search_keyword = CGI.unescape(params['search_keyword'] || '').scrub
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
      @direct_program_applications ||= DirectProgramApplication.joins(student: :user).where(where_clause).where(dpa_conditions)
                                                               .where(app_review_conditions).merge(User.search(search_keyword))
                                                               .select(direct_program_application_select)
    end

    def where_clause
      clause = { student_id: students.map(&:user_id) }

      clause = clause.merge(direct_program_applications: { is_form_complete: col_type_value }) if col_type == 'is_form_complete'
      clause = clause.merge(direct_program_applications: { status: 2, is_form_complete: true, explore_status: explore_status_ids }) if col_type == 'submission'

      clause
    end

    def app_review_conditions
      return '' unless col_type == 'app_review'

      app_reviewed_statuses = DirectProgramApplication.explore_statuses.slice('submitted_to_cialfo', 'submitted_to_university').values.join(',')
      app_not_reviewed_statuses = DirectProgramApplication.explore_statuses.slice('submitted_to_counselor', 'revision_required').values.join(',')
      return "direct_program_applications.status = 2 and direct_program_applications.is_form_complete = true and direct_program_applications.explore_status IN (#{app_reviewed_statuses})" if col_type_value

      "direct_program_applications.status = 2 and direct_program_applications.is_form_complete = true and (direct_program_applications.explore_status IN (#{app_not_reviewed_statuses}))" unless col_type_value
    end

    def dap_conditions
      conditions = { id: direct_program_applications.map(&:direct_apply_program_id) }
      return conditions if app_type.blank? || app_type == 'all' || ['ucas', 'da'].exclude?(app_type)

      conditions = conditions.merge(is_ucas: (app_type == 'ucas' && current_tenant.enable_direct_apply_ucas))
      conditions
    end

    def dpa_conditions
      return '' if app_type.blank? || app_type == 'all'
      return "direct_apply_program_id IN (#{region_based_dap_ids})" unless app_type.in?(['ucas', 'da'])

      dap_ids = dap_ucas_ids.join(',')
      return "direct_apply_program_id IN (#{dap_ids})" if app_type == 'ucas' && current_tenant.enable_direct_apply_ucas

      "direct_apply_program_id NOT IN (#{dap_ids})"
    end

    def explore_status_ids
      return DirectProgramApplication.explore_statuses.slice('submitted_to_counselor', 'revision_required', 'revision_requested_by_cialfo').values unless col_type_value

      DirectProgramApplication.explore_statuses.slice('submitted_to_cialfo', 'reviewing', 'submitted_to_university', 'pending_info', 'pending_decision', 'deposit_paid', 'cas_issued', 'visa_processing', 'visa_approved', 'visa_rejected', 'fees_paid', 'deposit_pending', 'pending_decision', 'pending_info').values
    end

    def direct_program_application_select
      "direct_program_applications.direct_apply_program_id, direct_program_applications.explore_application_id, CONCAT(users.first_name, ' ', users.last_name) as f_name, students.user_id as student_id"
    end

    def direct_apply_program_select
      'direct_apply_programs.id as id, direct_apply_programs.is_ucas, schools.image_logo, schools.name'
    end

    def order
      {
        'student_name asc' => 'users.last_name asc',
        'student_name desc' => 'users.last_name desc'
      }.dig("#{order_column} #{order_direction}")
    end
  end
end
