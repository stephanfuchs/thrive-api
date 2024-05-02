# frozen_string_literal: true

class UserAccount < ApplicationRecord
  self.table_name = 'user_account'
  include ElasticSearch::UserAccounts

  default_scope -> { active }

  belongs_to :user

  scope :active, -> { where(deletedat: nil, disabled: false) }
end
