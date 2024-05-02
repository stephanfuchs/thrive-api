# frozen_string_literal: true

module CounselorDashboards
  class DaDocumentsList < CounselorBase
    attr_reader :params, :document_type, :status, :page, :per_page, :order_column, :order_direction, :search_keyword

    def initialize(params, current_user)
      @params = params
      @document_type = params[:column_type]
      @status = params[:value]
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
      @base_query ||= base_table_joins.where(students: { user_id: students.map(&:user_id) }).where(where)
                                      .merge(User.search(search_keyword)).select(ddpa_select)
    end

    def base_table_joins
      @base_table_joins ||= if status == 'sent'
        DocumentDirectProgramApplication.joins(document: :document_type, direct_program_application: { student: :user })
      else
        Document.joins(:document_type, students: :user).joins(ddpa_joins)
      end
    end

    def ddpa_joins
      'LEFT JOIN document_direct_program_applications on document_direct_program_applications.document_id = documents.id' \
      ' LEFT JOIN direct_program_applications on document_direct_program_applications.direct_program_application_id = direct_program_applications.id'
    end

    def where
      return sent_conditions if status == 'sent'

      not_sent_conditions
    end

    def sent_conditions
      sent_status = DocumentDirectProgramApplication.statuses.slice('sent').values.join

      "document_types.id = #{document_type_id} AND document_direct_program_applications.status = #{sent_status} AND " \
      "direct_program_applications.direct_apply_program_id IN (#{dap_ucas_ids.join(',')}) "
    end

    def not_sent_conditions
      statuses = DocumentDirectProgramApplication.statuses.except('sent', 'rejected').values

      "document_types.id = #{document_type_id} AND (direct_program_applications.direct_apply_program_id IN (#{dap_ucas_ids.join(',')}) " \
      "AND document_direct_program_applications.status IN (#{statuses.join(',')}) OR document_direct_program_applications.document_id IS NULL)"
    end

    def document_type_id
      @document_type_id ||= if document_type == 'letter_of_reference'
        DocumentType::UCAS_REFERENCE_LETTER_ID
      else
        Constants::DocumentType::ENTRIES['predicted_grades']['id']
      end
    end

    def ddpa_select
      "direct_program_applications.direct_apply_program_id, CONCAT(users.first_name, ' ', users.last_name) as f_name, students.user_id as student_id"
    end

    def order
      {
        'last_name asc' => 'users.last_name asc',
        'last_name desc' => 'users.last_name desc'
      }.dig("#{order_column} #{order_direction}")
    end

    def dap_conditions
      {
        id: base_query.map(&:direct_apply_program_id),
        is_ucas: true
      }
    end

    def direct_apply_program_select
      'direct_apply_programs.id as id, schools.image_logo, schools.name'
    end
  end
end
