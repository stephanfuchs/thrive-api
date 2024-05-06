# frozen_string_literal: true

# INFO: (Stephan) good sources
#   1. https://tiagoamaro.com.br/2014/12/11/multi-tenancy-with-searchkick/
#   2. https://dev.to/mahmoudsultan36/patching-searchkich-gem-to-add-custom-queries-by-default-21m0

module ElasticSearch
  module People
    extend ActiveSupport::Concern
    included do
      searchkick default_fields: [:first_name, :last_name, :full_name, :reversed_full_name], word_start: [:first_name, :last_name, :full_name, :reversed_full_name], word: [:first_name, :last_name, :full_name, :reversed_full_name], callbacks: false, case_sensitive: false, merge_mappings: true

      scope :search_import, -> {
        includes(
          :person_contacts,
          person_companies: [:company],
        )
      }

      def search_data
        contacts_data = person_contacts.map { |contact| contact.slice(:id, :contact_type, :contact_value, :is_primary) }
        companies_data = person_companies.map do |person_company|
          {
            company: {
              type: person_company.company.type,
              id: person_company.company.id,
              name: person_company.company.name
            },
          }.merge(person_company.slice(:id, :is_current))
        end
        slice(
          :account_id,
          :id,
          :first_name,
          :last_name,
          :linkedin_url,
          :full_name,
          :reversed_full_name,
        ).merge(
          contacts: contacts_data,
          companies: companies_data,
        )
      end

      class << self
        def search(term)
          elastic_search(term.presence || '*',
            misspellings: { prefix_length: 2 },
            match: :word_start,
            operator: :and,
            limit: 10,
            load: false)&.results
        end
      end
    end
  end
end
