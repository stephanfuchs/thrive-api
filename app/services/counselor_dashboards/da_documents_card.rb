# frozen_string_literal: true

module CounselorDashboards
  class DaDocumentsCard < CounselorBase

    def initialize(params, current_user)
      super(params, current_user)
    end

    def call
      lor_doc_type_id = DocumentType::UCAS_REFERENCE_LETTER_ID
      predicted_grades_doc_type_id = Constants::DocumentType::ENTRIES['predicted_grades']['id']

      {
        letter_of_reference: {
          'true': ddpa.where(sent_conditions(lor_doc_type_id)).count,
          'false': not_sent_ddpa.where(not_sent_conditions(lor_doc_type_id)).count
        },
        predicted_grades: {
          'true': ddpa.where(sent_conditions(predicted_grades_doc_type_id)).count,
          'false': not_sent_ddpa.where(not_sent_conditions(predicted_grades_doc_type_id)).count
        }
      }
    end

    def sent_conditions(document_type_id)
      "document_types.id = #{document_type_id} AND document_direct_program_applications.status = #{DocumentDirectProgramApplication.statuses['sent']}"
    end

    def not_sent_conditions(document_type_id)
      statuses = DocumentDirectProgramApplication.statuses.slice('sent', 'rejected').values

      "document_types.id = #{document_type_id} AND (#{dap_conditions} document_direct_program_applications.status NOT IN (#{statuses.join(',')})" \
      ' OR document_direct_program_applications.document_id IS NULL)'
    end

    def dap_conditions
      return '' if dap_ucas_ids.blank?

      "direct_program_applications.direct_apply_program_id IN (#{dap_ucas_ids.join(',')}) AND "
    end

    def not_sent_ddpa
      @not_sent_ddpa ||= Document.joins(:students, :document_type).joins(ddpa_joins).where(students: { user_id: students.map(&:user_id) })
    end

    def ddpa_joins
      'LEFT JOIN document_direct_program_applications on document_direct_program_applications.document_id = documents.id' \
      ' LEFT JOIN direct_program_applications on document_direct_program_applications.direct_program_application_id = direct_program_applications.id'
    end

    def ddpa
      @ddpa ||= DocumentDirectProgramApplication.joins(:direct_program_application, document: :document_type).where(dpa_conditions)
    end

    def dpa_conditions
      {
        direct_program_applications: { student_id: students.map(&:user_id), direct_apply_program_id: dap_ucas_ids }
      }
    end
  end
end
