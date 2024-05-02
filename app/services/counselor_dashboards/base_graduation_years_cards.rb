# frozen_string_literal: true

module CounselorDashboards
  class BaseGraduationYearsCards < BaseCards
    def initialize(tenant, graduation_years, mentor_id: nil)
      check_type_error(tenant, graduation_years)
      super(tenant, mentor_id)
      @graduation_years = graduation_years
    end

    def graduation_year_wrapper_body(inner_body = nil)
      {
        graduation_year: {
          terms: {
            field: :graduation_year
          },
          aggs: inner_body
        }.deep_clean
      }
    end

    def graduation_year_query
      {
        where: {
          graduation_year: graduation_years
        },
      }
    end

    def query_hash
      [
        super,
        graduation_year_query,
      ].inject(&:deep_merge)
    end
  end
end
