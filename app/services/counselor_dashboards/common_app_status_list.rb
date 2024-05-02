# frozen_string_literal: true

module CounselorDashboards
  class CommonAppStatusList < CounselorBase
    attr_reader :params, :col_type, :col_value, :page, :per_page, :order_column, :order_direction, :search_keyword

    def initialize(params, current_user)
      @params = params
      @col_type = params['column_type']
      @col_value = params.key?('value') ? YAML.safe_load(params['value'].to_s) : true
      @page = params[:page]
      @per_page = 20
      @order_column = params[:order_column] || 'last_name'
      @order_direction = params[:order_direction] || 'asc'
      @search_keyword = CGI.unescape(params['search_keyword'] || '').scrub
      super(params, current_user)
    end

    def call
      final_query
    end

    def total_count
      final_query.total_entries
    end

    def applying_to_ca_student_ids
      @applying_to_ca_student_ids ||= StudentCollege.common_app.where(student_id: students.map(&:id)).where(list_id: StudentCollege::LIST_IDS[:finalised]).pluck(:student_id)
    end

    private

    def final_query
      @final_query ||= base_query.joins(:user).select(select).order(order).paginate(page: page, per_page: per_page)
    end

    def base_query
      @base_query ||= if col_type == 'waived'
        ferpa_status_students
      elsif col_type == 'common_app_linked'
        common_app_students
      end
    end

    def ferpa_status_students
      return students.waived if col_value

      students.where.not(ferpa_status: 1)
    end

    def common_app_students
      Student.where(user_id: common_app_linked_student_ids)
    end

    def common_app_linked_student_ids
      return CommonAppAccount.where(tenant_id: current_tenant.id, user_id: students.map(&:user_id)).where.not(common_app_id: nil).pluck(:user_id) if col_value

      CommonAppAccount.where(tenant_id: current_tenant.id, user_id: students.map(&:user_id)).where(common_app_id: nil).pluck(:user_id)
    end

    def order
      {
        'student_name asc' => 'users.last_name asc',
        'student_name desc' => 'users.last_name desc',
        'status asc' => 'FIELD(students.ferpa_status, 0, 2)',
        'status desc' => 'FIELD(students.ferpa_status, 2, 0)'
      }.dig("#{order_column} #{order_direction}")
    end

    def select
      'user_id, first_name, last_name, ferpa_status'
    end
  end
end
