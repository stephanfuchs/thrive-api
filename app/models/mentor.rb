# frozen_string_literal: true

class Mentor < ApplicationRecord
  self.primary_key = :user_id

  has_many :student_mentors
  has_many :students, through: :student_mentors
end
