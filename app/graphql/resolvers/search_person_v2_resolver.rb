module Resolvers
  class SearchPersonV2Resolver < GraphQL::Schema::Resolver
    argument :searchTerm, String, required: true
    argument :exact, Boolean, required: false, default_value: false
    argument :limit, Integer, required: false, default_value: 20
    argument :offset, Integer, required: false, default_value: 0
    argument :email_search, Boolean, required: false, default_value: true

    type Types::SearchPersonV2Type, null: true

    def resolve(searchTerm:, exact:, limit:, offset:, email_search:)
      puts 'hello!'
      binding.pry
      # Your logic to fetch data based on the arguments provided
    end
  end
end
