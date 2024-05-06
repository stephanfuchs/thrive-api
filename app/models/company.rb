# frozen_string_literal: true

class Company < ApplicationRecord
  self.table_name = 'company'
  include ElasticSearch::Companies
  self.inheritance_column = 'ignore_type' # INFO: (Stephan) type column has a special purpose in Rails and in this case needs to be changed to another column to avoid conflict

  has_many :person_companies
  has_many :people, through: :person_companies
end
