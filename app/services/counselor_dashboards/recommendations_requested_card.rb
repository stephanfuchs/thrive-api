# frozen_string_literal: true

module CounselorDashboards
  class RecommendationsRequestedCard < CounselorBase
    def initialize(params, current_user)
      super(params, current_user)
    end

    def call
      {
        'true' => recommendations_requested_count,
        'false' => students.includes(:student_document_requests).references(:student_document_requests).where('student_document_requests.student_id is NULL').count
      }
    end

    def recommendations_requested_count
      StudentDocumentRequest.where(student_id: students.map(&:id)).joins(:document_request_entries)
                            .where(document_request_entries: { request_status: DocumentRequestEntry.request_statuses.except(:cancelled).values })
                            .count
    end
  end
end
