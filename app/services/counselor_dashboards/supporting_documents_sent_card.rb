# frozen_string_literal: true

module CounselorDashboards
  class SupportingDocumentsSentCard < CounselorBase
    def initialize(params, current_user)
      super(params, current_user)
    end

    def call
      {
        "initial": students.initial.size,
        "mid_year": students.mid_year.size,
        "final": students.final.size,
        "no_status": students.where(document_completion_status: nil).size
      }
    end
  end
end
