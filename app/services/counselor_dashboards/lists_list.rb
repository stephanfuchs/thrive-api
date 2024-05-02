# frozen_string_literal: true

# CounselorDashboards::ListsList.new(Tenant.first).call(2024)
# CounselorDashboards::ListsList.new(Tenant.first, 2024, in_list: false)

module CounselorDashboards
  class ListsList < BaseGraduationYearsLists
    attr_reader :tenant_uuid,
      :mentor_id,
      :graduation_year,
      :in_list,
      :list_type,
      :page,
      :order_column,
      :order_direction

    def allowed_entries
      super.deep_merge!({
        list_type: StudentCollege::IN_LIST_IDS_HASH.keys,
        order_column: [:count, :last_name],
      }.with_indifferent_access)
    end

    # in_list: nil, list_type: nil, page: nil, order_column: nil, order_direction: nil, mentor_id: nil
    def initialize(tenant, graduation_year, in_list: nil, list_type: nil, **lists_args)
      super(tenant, graduation_year, **lists_args)
      @in_list = in_list.to_s.to_boolean
      @list_type = clean_entries(:list_type, list_type)
      # INFO: (Stephan) special case when count is being ordered by
      order_column_list_type = @list_type.dup.to_s.prepend('lists_counts.').to_sym
      @order_column = order_column_list_type if @order_column == :count
    end

    def call
      OpenStruct.new(
        list: search.results,
        count: search.total_entries,
        list_type: list_type
      )
    end

    def selection_entries
      super.append([
        :lists_counts,
      ]).flatten
    end

    def list_type_query
      list_type_where = list_type.dup.to_s.prepend('lists_stats.').to_sym
      # INFO: (Stephan) source of magic https://www.bounga.org/ruby/2020/04/08/creating-a-deeply-nested-hash-in-ruby/
      base_hash = Hash.new { |h, k| h[k] = h.dup.clear }
      base_hash[:where][list_type_where] = in_list
      base_hash
    end

    def query_hash
      [
        super,
        list_type_query,
      ].inject(&:deep_merge)
    end
  end
end
