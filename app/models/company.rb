# frozen_string_literal: true

class Company < ApplicationRecord
  self.table_name = 'company'
  include ElasticSearch::Companies
  self.inheritance_column = 'whatever'

  # has_many :user_accounts
end
