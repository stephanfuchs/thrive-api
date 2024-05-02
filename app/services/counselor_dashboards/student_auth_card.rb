# frozen_string_literal: true

module CounselorDashboards
  class StudentAuthCard < CounselorBase
    def initialize(params, current_user)
      super(params, current_user)
    end

    def call
      {
        authenticated_students_count: { true: authenticated_students_count > 0 ? authenticated_students_count : '', false: '' },
        unauthenticated_students_count: { true: '', false: unauthenticated_students_count > 0 ? unauthenticated_students_count : '' }
      }
    end

    def unauthenticated_students
      @unauthenticated_students ||= students.joins('LEFT JOIN user_signatures as signatures on students.user_id = signatures.user_id')
                                                 .where(signatures: { user_id: nil })
    end

    private

    def authenticated_students_count
      @authenticated_students_count ||= students.joins(user: :signature).where(users: { has_accepted_conditions: true }).distinct.count
    end

    def unauthenticated_students_count
      @unauthenticated_students_count ||= unauthenticated_students.distinct.count
    end
  end
end
