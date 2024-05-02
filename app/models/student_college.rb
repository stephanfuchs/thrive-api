# frozen_string_literal: true

class StudentCollege < ApplicationRecord
  include ElasticSearch::UsersDynamicReindex

  LIST_IDS = {
    finalised: 3,
    shortlisted: 2,
    research: 1,
    longlist: 4
  }.freeze

  IN_LIST_IDS_HASH = StudentCollege::LIST_IDS.slice(:finalised, :shortlisted, :longlist)

  enum delivery_type: %I[parchment common_app nacac tenant mail direct_apply]

  has_many  :student_school_applications

  scope :finalized, -> { where(list_id: StudentCollege::LIST_IDS[:finalised]) }

  class << self
    def get_colleges(user_id)
      StudentCollege.joins(:student_school_applications)
                    .where(student_id: user_id, is_delete: false)
                    .where.not(student_school_applications: { list_id: LIST_IDS[:research] })
                    .merge(StudentSchoolApplication.not_withdrawn)
                    .select([
                        'student_colleges.*',
                        'student_school_applications.list_id AS app4_list_id'
                      ])
    end
  end
end
