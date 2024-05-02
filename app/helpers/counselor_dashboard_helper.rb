# frozen_string_literal: true

module CounselorDashboardHelper
  def explore_result(result)
    return 'No Status' if result.blank?

    Constants::DirectProgramApplication::EXPLORE_RESULT_MAPPING.key(result.to_sym)
  end
end
