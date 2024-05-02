# frozen_string_literal: true

# CounselorDashboards::AssesmentsCard.new(Tenant.first, 2022..2025, mentor_id: 123).base_card_hash
# CounselorDashboards::AssesmentsCard.new(Tenant.first, 2022..2025, mentor_id: 123).query_hash

module CounselorDashboards
  class AssesmentsCard < BaseGraduationYearsCards
    attr_reader :tenant_uuid,
      :mentor_id,
      :graduation_years,
      :assesment_type_names

    def initialize(tenant, graduation_years, mentor_id: nil)
      super(tenant, graduation_years, mentor_id: mentor_id)
      @assesment_type_names =
        Constants::Assessments::AVAILABLE.map { |assesment_entry| assesment_entry[:student_search_key].dup.prepend('assesments_completed.') }
    end

    def base_card_hash
      [*graduation_years].reduce({}) do |graduation_years_hash, graduation_year|
        graduation_years_hash[graduation_year] =
          assesment_type_names.reduce({}) do |return_hash, assesment_type_name|
            return_hash[assesment_type_name] = { true: 0, false: 0 }.with_indifferent_access
            return_hash
          end
        graduation_years_hash
      end.nested_under_indifferent_access
    end

    def aggs_body
      assesments_counts_aggs_query =
        assesment_type_names.reduce({}) do |return_hash, assesment_type_name|
          return_hash[assesment_type_name.to_sym] = { terms: { field: assesment_type_name } }
          return_hash
        end

      graduation_year_wrapper_body(assesments_counts_aggs_query)
    end
  end
end
