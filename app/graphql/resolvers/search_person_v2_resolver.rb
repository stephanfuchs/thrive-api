module Resolvers
  class SearchPersonV2Resolver < GraphQL::Schema::Resolver
    argument :searchTerm, String, required: true
    argument :exact, Boolean, required: false, default_value: false
    argument :limit, Integer, required: false, default_value: 20
    argument :offset, Integer, required: false, default_value: 0
    argument :email_search, Boolean, required: false, default_value: true

    type [Types::SearchPersonV2Type], null: true

    def resolve(searchTerm:, exact:, limit:, offset:, email_search:)
      # Perform search using searchkick
      persons = Person.search(
        searchTerm,
        # match: :word_start,
        # misspellings: {below: 5},
        # fields: [:first_name, :last_name],
        # offset: offset
      )

      # Apply additional filters if needed
      # persons = persons.where(email: searchTerm) if email_search
      # persons = persons.where(first_name: searchTerm).or(Person.where(last_name: searchTerm)) if exact

      # Initialize an array to hold search results
      search_results = []

      # Loop through the search results and build the response
      persons.each do |person|
        result = {
          contacts: [],
          company: [],
          id: person.id,
          first_name: person.first_name,
          last_name: person.last_name
        }

        # Fetch contacts for the person
        # binding.pry if person.contacts
        # binding.pry
        result[:contacts] = person.contacts&.map do |contact|
          {
            is_primary: contact.is_primary,
            contact_value: contact.contact_value,
            contact_type: contact.contact_type,
            id: contact.id
          }
        end || []
        # result[:contacts] = person.contacts

        # Fetch companies for the person
        # person.companies.each do |company|
        #   company_data = {
        #     company: {
        #       type: company.type,
        #       id: company.id,
        #       name: company.name
        #     },
        #     is_current: company.is_current,
        #     id: company.id
        #   }
        #   result[:company] << company_data
        # end

        search_results << result
      end

      search_results
    end
  end
end
