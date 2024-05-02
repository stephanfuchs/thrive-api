# frozen_string_literal: true

module CounselorDashboards
  class StudentAuthList
    attr_reader :graduation_year, :all_students, :current_user, :authenticated, :page, :per_page, :order_column, :order_direction, :search_keyword, :dashboard_user_id

    def initialize(params, current_user)
      @graduation_year = graduation_year
      @authenticated = params.key?('authenticated') ? YAML.safe_load(params['authenticated'].to_s) : true
      @page = params[:page_no]
      @per_page = 20
      @order_column = params[:order_column] || 'name'
      @order_direction = params[:order_direction] || 'asc'
      @search_keyword = CGI.unescape(params['search_keyword'] || '').scrub
      @current_user = current_user
      @dashboard_user_id = params[:dashboard_user_id]
    end

    def call
      final_query
    end

    def total_count
      final_query.total_entries
    end

    private

    def graduation_year
      date = Time.now
      return date.year + 1 if date.month >= 8
      date.year
    end

    def base_query
      @base_query ||= begin
        return authenticated_students if authenticated
        unauthenticated_students
      end
    end

    def final_query
      @final_query ||= base_query.order(order).paginate(page: page, per_page: per_page)
    end

    def authenticated_students
      students.joins(:user)
              .joins('INNER JOIN user_signatures as signatures on users.id = signatures.user_id')
              .where(users: { has_accepted_conditions: true }).merge(User.search(search_keyword)).distinct
              .select(select)
    end

    def unauthenticated_students
      User.joins('LEFT JOIN user_signatures as signatures on users.id = signatures.user_id')
          .where(id: students.map(&:id), signatures: { user_id: nil }).merge(User.search(search_keyword)).distinct
          .select(select)
    end

    def select
      "CONCAT(users.first_name, ' ', users.last_name) as f_name, signatures.created_at, users.last_name"
    end

    def order
      "#{order_col[order_column]} #{order_direction}"
    end

    def order_col
      {
        'name' => 'users.last_name',
        'date_time' => 'signatures.created_at'
      }
    end

    def dashboard_user
      @dashboard_user ||= begin
        return current_user if current_user.mentor? && !current_user.admin?
        User.find_by(id: dashboard_user_id)
      end
    end

    def students
      @students ||= begin
        if dashboard_user_id.blank? && current_user.admin?
          Student.where(graduation_year: graduation_year)
        else
          dashboard_user.mentor.students.where(graduation_year: graduation_year)
        end
      end
    end
  end
end
