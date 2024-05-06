# frozen_string_literal: true

class PersonCompany < ApplicationRecord
  self.table_name = 'person_company'

  belongs_to :person
  belongs_to :company
end
