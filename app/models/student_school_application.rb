class StudentSchoolApplication < ApplicationRecord

  scope :not_withdrawn, -> { where(is_withdrawn: false) }
end
