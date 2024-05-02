# frozen_string_literal: true

# CounselorDashboards::AssesmentsList.new(Tenant.first).call(2024)
# CounselorDashboards::AssesmentsList.new(Tenant.first, 2024, completed: false, order_column: 'status', order_direction: 'asc', assesment_type: 'personality', mentor_id: 123, page: 2)

module CounselorDashboards
  class AssesmentsList < BaseGraduationYearsLists
    attr_reader :tenant_uuid,
      :mentor_id,
      :graduation_year,
      :completed,
      :assesment_type,
      :page,
      :order_column,
      :order_direction

    def allowed_entries
      super.deep_merge!({
        assesment_type: Constants::Assessments::AVAILABLE.map { |assesment_entry| assesment_entry[:student_search_key].to_sym },
        order_column: [:status, :last_name],
      }.with_indifferent_access)
    end

    # completed: nil, assesment_type: nil, page: nil, order_column: nil, order_direction: nil, mentor_id: nil
    def initialize(tenant, graduation_year, completed: nil, assesment_type: nil,  **lists_args)
      super(tenant, graduation_year, **lists_args)
      @completed = completed.to_s.to_boolean
      @assesment_type = clean_entries(:assesment_type, assesment_type)
      # INFO: (Stephan) special case when status is being ordered by
      order_column_assesment_type = @assesment_type.dup.to_s.prepend('assesments_states.').to_sym
      @order_column = order_column_assesment_type if @order_column == :status
    end

    def call
      OpenStruct.new(
        list: search.results,
        count: search.total_entries,
        assesment_type: assesment_type
      )
    end

    def selection_entries
      super.append([
        :assesments_states,
      ]).flatten
    end

    def assesment_type_query
      assesment_type_where = assesment_type.dup.to_s.prepend('assesments_completed.').to_sym
      # INFO: (Stephan) source of magic https://www.bounga.org/ruby/2020/04/08/creating-a-deeply-nested-hash-in-ruby/
      base_hash = Hash.new { |h, k| h[k] = h.dup.clear }
      base_hash[:where][assesment_type_where] = completed
      base_hash
    end

    def query_hash
      [
        super,
        assesment_type_query,
      ].inject(&:deep_merge)
    end
  end
end
