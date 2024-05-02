# frozen_string_literal: true

# CounselorDashboards::LastLoginList.new(Tenant.first).call(2024, Date.parse('2022-02-25').to_datetime)
# CounselorDashboards::LastLoginList.new(Tenant.first, 2024, Date.parse('2022-02-25').to_datetime, signed_in: false)

module CounselorDashboards
  class LastLoginList < BaseGraduationYearsLists
    attr_reader :tenant_uuid,
      :mentor_id,
      :graduation_year,
      :cutoff_datetime,
      :signed_in,
      :page,
      :order_column,
      :order_direction


    def allowed_entries
      super.deep_merge!({
        order_column: [:last_login, :last_name],
      }.with_indifferent_access)
    end

    # signed_in: nil, page: nil, order_column: nil, order_direction: nil, mentor_id: nil
    def initialize(tenant, graduation_year, cutoff_datetime, signed_in: nil, **lists_args)
      check_type_error(cutoff_datetime)
      super(tenant, graduation_year, **lists_args)
      @cutoff_datetime = cutoff_datetime
      @signed_in = signed_in.to_s.to_boolean
    end

    def selection_entries
      super.append([
        :last_login,
      ]).flatten
    end

    def last_login_comparison_query
      # INFO: (Stephan) source of magic https://www.bounga.org/ruby/2020/04/08/creating-a-deeply-nested-hash-in-ruby/
      base_hash = Hash.new { |h, k| h[k] = h.dup.clear }
      base_hash[:where][:last_login_comparison][signed_in ? :gte : :lte] = cutoff_datetime
      base_hash
    end

    def query_hash
      [
        super,
        last_login_comparison_query,
      ].inject(&:deep_merge)
    end
  end
end
