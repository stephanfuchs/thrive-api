class StudentMentor < ApplicationRecord
  include ElasticSearch::UsersDynamicReindex

  acts_as_paranoid

  belongs_to :student, :foreign_key => "student_id"
end
