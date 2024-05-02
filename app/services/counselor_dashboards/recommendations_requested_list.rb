# frozen_string_literal: true

module CounselorDashboards
  class RecommendationsRequestedList < CounselorBase
    attr_reader :params, :col_type_value, :page, :per_page, :order_column, :order_direction, :search_keyword

    def initialize(params, current_user)
      @params = params
      @col_type_value = params.key?('value') ? YAML.safe_load(params['value'].to_s) : true
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

    def recommendations_required_count_hash
      recommendations_required_count_hash = {}
      user_college_hash.keys.each do |u_id|
        recommendations_required_count_hash[u_id] = school_ca_teacher_eval_hash.values_at(*user_college_hash[u_id]).compact.max
      end

      recommendations_required_count_hash
    end

    private

    def final_query
      @final_query ||= base_query.select(select).group(:user_id).order(order).paginate(page: page, per_page: per_page)
    end

    def base_query
      @base_query ||= sdr_students
    end

    def sdr_students
      return students.joins(:user, student_document_requests: :document_request_entries)
                     .where(document_request_entries: { request_status: DocumentRequestEntry.request_statuses.except(:cancelled).values }) if col_type_value

      students.joins(:user, 'LEFT JOIN student_document_requests ON students.user_id = student_document_requests.student_id ').where('student_document_requests.student_id is NULL')
    end

    def order
      {
        'student_name asc' => 'users.last_name asc',
        'student_name desc' => 'users.last_name desc'
      }.dig("#{order_column} #{order_direction}")
    end

    def select
      'user_id, first_name, last_name, COUNT(student_document_requests.student_id) as recommendation_requests_size'
    end

    def user_college_hash
      @user_college_hash ||= StudentCollege.finalized.where(student_id: students.map(&:id)).select('student_id, college_id').group_by(&:student_id).map { |key, value| [key, value.map(&:college_id)] }.to_h
    end

    def school_ca_teacher_eval_hash
      @school_ca_teacher_eval_hash ||= School.where(id: user_college_hash.values.flatten.uniq).pluck(:id, :ca_teacher_eval_num).to_h
    end
  end
end
