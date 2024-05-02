# frozen_string_literal: true

# CounselorDashboards::LastLoginCard.new(Tenant.first, 2022..2025, Date.parse('2022-02-25').to_datetime).base_card_hash
# CounselorDashboards::LastLoginCard.new(Tenant.first, 2022..2025, Date.parse('2022-02-25').to_datetime).query_hash

module CounselorDashboards
  class LastLoginCard < BaseGraduationYearsCards
    attr_reader :tenant_uuid,
      :mentor_id,
      :graduation_years,
      :cutoff_datetime

    def initialize(tenant, graduation_years, cutoff_datetime, mentor_id: nil)
      check_type_error(cutoff_datetime)
      super(tenant, graduation_years, mentor_id: mentor_id)
      @cutoff_datetime = cutoff_datetime
    end

    def base_card_hash
      [*graduation_years].reduce({}) do |return_hash, graduation_year|
        return_hash[graduation_year] = { 'logged_in': { false: 0, true: 0 } }
      return_hash
      end.nested_under_indifferent_access
    end

    def aggs_body
      graduation_year_wrapper_body(
        logged_in: {
          range: {
            field: :last_login_comparison,
            ranges: [
              { key: 'false', to: cutoff_datetime },
              { key: 'true', from: cutoff_datetime },
            ]
          }
        }
      )
    end
  end
end
