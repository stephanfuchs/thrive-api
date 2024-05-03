# frozen_string_literal: true

# INFO: (Stephan) good sources
#   1. https://tiagoamaro.com.br/2014/12/11/multi-tenancy-with-searchkick/
#   2. https://dev.to/mahmoudsultan36/patching-searchkich-gem-to-add-custom-queries-by-default-21m0

module ElasticSearch
  module Companies
    extend ActiveSupport::Concern
    included do
      searchkick default_fields: [:name, :website], word_start: [:name, :website], word: [:name, :website], callbacks: false, case_sensitive: false, merge_mappings: true

      def search_data
        slice(
          :name,
          :website,
        )
      end

      class << self
        def search(term)
          elastic_search(term.presence || '*',
            misspellings: { prefix_length: 2 },
            match: :word_start,
            operator: :or,
            load: false)&.results
        end
      end
    end
  end
end
