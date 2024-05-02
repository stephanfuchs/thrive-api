# frozen_string_literal: true

class CommonAppAccount < ApplicationRecord
  belongs_to :tenant
  belongs_to :user

  RESET_SUBMISSION = 'reset_submissions'
  UNLINKING = 'unlinking'
  ACTIONS = [RESET_SUBMISSION, UNLINKING]

  enum action: ACTIONS.map { |action| [action, action] }.to_h

  serialize :response, JSON
end
