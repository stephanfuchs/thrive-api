# frozen_string_literal: true

class PersonContact < ApplicationRecord
  self.table_name = 'person_contact'

  belongs_to :person
end
