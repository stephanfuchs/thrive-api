# frozen_string_literal: true

module CounselorDashboards
  class SupportingDocumentsSentList < CounselorBase
    attr_reader :params, :col_type_value, :page, :per_page, :order_column, :order_direction, :search_keyword, :current_user

    def initialize(params, current_user)
      @params = params
      @col_type_value = params.key?('value') ? YAML.safe_load(params['value'].to_s) : 'initial'
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

    def no_of_applications_hash
      @no_of_applications_hash ||= StudentCollege.where(list_id: 3).group(:student_id).count.to_h
    end

    private

    def final_query
      @final_query ||= base_query.joins(:user).select(select).order(order).paginate(page: page, per_page: per_page)
    end

    def base_query
      @base_query ||= sds_students
    end

    def sds_students
      return students.public_send(col_type_value) if students.document_completion_statuses.include?(col_type_value)

      students.where(document_completion_status: nil)
    end

    def order
      {
        'student_name asc' => 'users.last_name asc',
        'student_name desc' => 'users.last_name desc'
      }.dig("#{order_column} #{order_direction}")
    end

    def select
      'user_id, first_name, last_name, document_completion_status'
    end
  end
end
