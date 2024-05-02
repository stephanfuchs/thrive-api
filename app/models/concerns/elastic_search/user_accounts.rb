# frozen_string_literal: true

# INFO: (Stephan) good sources
#   1. https://tiagoamaro.com.br/2014/12/11/multi-tenancy-with-searchkick/
#   2. https://dev.to/mahmoudsultan36/patching-searchkich-gem-to-add-custom-queries-by-default-21m0

module ElasticSearch
  module UserAccounts
    extend ActiveSupport::Concern
    included do
      searchkick default_fields: [:first_name, :last_name], word_start: [:first_name, :last_name], word: [:first_name, :last_name], callbacks: false, case_sensitive: false, merge_mappings: true

      def search_data
        slice(
          :first_name,
          :id,
          :last_name,
        )
      end

      class << self
        def search(term)
          elastic_search(term.presence || '*',
            misspellings: { prefix_length: 2 },
            match: :word_start,
            load: false)&.results
        end
      end
    end
  end
end
