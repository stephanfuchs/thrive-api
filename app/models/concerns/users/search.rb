# frozen_string_literal: true

module Users
  module Search
    extend ActiveSupport::Concern
    included do
      class << self
        def search(search_source_input_values)
          return where(none) if search_source_input_values.blank?
          search_query_entries = [
            search_users(search_source_input_values).select(:id).to_sql,
            search_integrations(search_source_input_values).select(:id).to_sql ]

          where(or_merge_subqueries(search_query_entries))
        end

        def search_integrations(search_source_input_values)
          joins(:user_integrations).merge(UserIntegration.search(search_source_input_values))
        end

        def search_users(search_source_input_values)
          base_search_cleaning(search_source_input_values) do |search_params|
            where(
              '(concat(users.first_name, users.last_name) like (:search_params)) OR ' \
              '(concat(users.last_name, users.first_name) like (:search_params)) OR ' \
              '(users.middle_name like (:search_params)) OR ' \
              '(users.preferred_name like (:search_params)) OR ' \
              '(users.personal_email like (:search_params)) OR ' \
              '(users.email like (:search_params))',
              search_params: search_params)
          end
        end
      end
    end
  end
end
