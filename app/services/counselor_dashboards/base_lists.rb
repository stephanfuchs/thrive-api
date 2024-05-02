# frozen_string_literal: true

module CounselorDashboards
  class BaseLists < Base
    attr_reader :tenant_uuid,
      :mentor_id,
      :page,
      :order_column,
      :order_direction

    PER_PAGE = 50

    def initialize(tenant, page: nil, order_column: nil, order_direction: nil, mentor_id: nil, **)
      super(tenant, mentor_id)
      @page = page.presence || 1
      @order_column = clean_entries(:order_column, order_column)
      @order_direction = clean_entries(:order_direction, order_direction)
    end

    def allowed_entries
      {
        order_direction: [:desc, :asc]
      }.with_indifferent_access
    end

    def order
      # INFO: (Stephan) source of magic https://www.bounga.org/ruby/2020/04/08/creating-a-deeply-nested-hash-in-ruby/
      base_hash = Hash.new { |h, k| h[k] = h.dup.clear }
      base_hash[:order][order_column] = order_direction
      base_hash
    end

    def selection_entries
      [:id, :first_name, :last_name, :preferred_name]
    end

    def selection
      {
        select: selection_entries
      }
    end

    def pagination
      {
        page: page,
        per_page: PER_PAGE,
      }
    end

    def query_hash
      [
        super,
        selection,
        pagination,
        order,
      ].inject(&:deep_merge)
    end

    def call
      OpenStruct.new(
        list: search.results,
        count: search.total_entries
      )
    end
  end
end
