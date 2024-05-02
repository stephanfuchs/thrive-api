# frozen_string_literal: true

module CounselorDashboards
  class BaseGraduationYearsLists < BaseLists
    attr_reader :tenant_uuid,
      :mentor_id,
      :graduation_year,
      :page,
      :order_column,
      :order_direction

    def initialize(tenant, graduation_year, **lists_args)
      check_type_error(graduation_year)
      super(tenant, **lists_args)
      @graduation_year = graduation_year
    end

    def selection_entries
      super.append([
        :graduation_year,
      ]).flatten
    end

    def graduation_year_query
      {
        where: {
          graduation_year: graduation_year
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
