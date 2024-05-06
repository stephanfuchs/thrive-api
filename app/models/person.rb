# frozen_string_literal: true

class Person < ApplicationRecord
  self.table_name = 'person'
  include ElasticSearch::People

  has_many :person_contacts
end
