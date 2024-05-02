# frozen_string_literal: true

class User < ApplicationRecord
  self.table_name = 'user'

  has_many :user_accounts
end
