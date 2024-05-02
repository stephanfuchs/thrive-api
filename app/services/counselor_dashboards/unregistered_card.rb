# frozen_string_literal: true

# CounselorDashboards::UnregisteredCard.new(Tenant.first, 2022..2025).base_card_hash
# CounselorDashboards::UnregisteredCard.new(Tenant.first, 2022..2025).query_hash
# Compare (should equal):
#   1. Student.joins(:user).merge(User.student.active.confirmed.not_deleted.where(last_login: nil)).group(:graduation_year).count
#   2. CounselorDashboards::UnregisteredCard.new(Tenant.first, 2022..2025).call

module CounselorDashboards
  class UnregisteredCard < BaseGraduationYearsCards
    attr_reader :tenant_uuid,
      :mentor_id,
      :graduation_years

    def base_card_hash
      [*graduation_years].reduce({}) do |return_hash, graduation_year|
        return_hash[graduation_year] = { registered: { true: 0, false: 0 } }.with_indifferent_access
      return_hash
      end.nested_under_indifferent_access
    end

    def aggs_body
      graduation_year_wrapper_body(
        registered: { terms: { field: :registered } }
      )
    end
  end
end
