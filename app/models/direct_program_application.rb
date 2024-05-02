class DirectProgramApplication < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :student

  enum explore_status: Constants::DirectProgramApplication::EXPLORE_STATUSES
  enum result: Constants::DirectProgramApplication::RESULTS
  enum status: [:unsubmitted, :submitting, :submitted, :error]
end
