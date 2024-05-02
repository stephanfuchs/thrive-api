# frozen_string_literal: true

# CounselorDashboards::ListsCard.new(Tenant.first, 2022..2025, mentor_id: 123).base_card_hash
# CounselorDashboards::ListsCard.new(Tenant.first, 2022..2025, mentor_id: 123).query_hash

module CounselorDashboards
  class ListsCard < BaseGraduationYearsCards
    attr_reader :tenant_uuid,
      :mentor_id,
      :graduation_years,
      :lists_names

    def initialize(tenant, graduation_years, mentor_id: nil)
      super(tenant, graduation_years, mentor_id: mentor_id)
      @lists_names =
        StudentCollege::IN_LIST_IDS_HASH.keys.map { |list_name| list_name.to_s.dup.prepend('lists_stats.') }
    end

    def base_card_hash
      [*graduation_years].reduce({}) do |graduation_years_hash, graduation_year|
        graduation_years_hash[graduation_year] =
          lists_names.reduce({}) do |return_hash, lists_name|
            return_hash[lists_name.to_sym] = { true: 0, false: 0 }.with_indifferent_access
            return_hash
          end.with_indifferent_access
        graduation_years_hash
      end.nested_under_indifferent_access
    end

    def aggs_body
      lists_stats_aggs_query =
        lists_names.reduce({}) do |return_hash, assesment_type_name|
          return_hash[assesment_type_name.to_sym] = { terms: { field: assesment_type_name } }
          return_hash
        end

      graduation_year_wrapper_body(lists_stats_aggs_query)
    end
  end
end
