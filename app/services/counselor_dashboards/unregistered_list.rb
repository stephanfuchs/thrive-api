# frozen_string_literal: true

# CounselorDashboards::UnregisteredList.new(Tenant.first, 2024)
# CounselorDashboards::UnregisteredList.new(Tenant.first, 2024, registered: false, page: 2, order_column: 'last_name', order_direct: 'asc', mentor_id: 123)

module CounselorDashboards
  class UnregisteredList < BaseGraduationYearsLists
    attr_reader :tenant_uuid,
      :mentor_id,
      :graduation_year,
      :registered,
      :page,
      :order_column,
      :order_direction

    def allowed_entries
      super.deep_merge!({
        order_column: [:last_registration_sent_at, :last_login, :last_name],
      }.with_indifferent_access)
    end

    # registered: nil, page: nil, order_column: nil, order_direction: nil, mentor_id: nil
    def initialize(tenant, graduation_year, registered: nil, **lists_args)
      super(tenant, graduation_year, **lists_args)
      @registered = registered.to_s.to_boolean
    end

    def call
      OpenStruct.new(
        list: search.results,
        count: search.total_entries,
        registered: registered
      )
    end

    def selection_entries
      super.append([
        :last_registration_sent_at,
        :last_login,
      ]).flatten
    end

    def registered_query
      # INFO: (Stephan) source of magic https://www.bounga.org/ruby/2020/04/08/creating-a-deeply-nested-hash-in-ruby/
      base_hash = Hash.new { |h, k| h[k] = h.dup.clear }
      base_hash[:where][:registered] = registered
      base_hash
    end

    def query_hash
      [
        super,
        registered_query,
      ].inject(&:deep_merge)
    end
  end
end
