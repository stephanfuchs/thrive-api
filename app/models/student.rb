# frozen_string_literal: true

class Student < ApplicationRecord
  include ElasticSearch::UsersDynamicReindex

  self.primary_key = :user_id

  belongs_to :user, foreign_key: 'user_id'

  has_and_belongs_to_many :documents

  has_many :student_colleges
  has_many :student_document_requests
  has_many :student_mentors

  enum document_completion_status: %w[initial mid_year final]
  enum ferpa_status: %w[unanswered waived not_waived]

  scope :not_deleted, -> { joins(:user).where('users.is_deleted = false') }
  scope :active, -> { not_deleted.where('users.is_active = true') }
end
