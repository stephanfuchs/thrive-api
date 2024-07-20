# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

    description "The query root of this schema"

    field :post, resolver: Resolvers::PostResolver
    # Define your SearchPersonV2 query here
    field :searchPerson_v2, resolver: Resolvers::SearchPersonV2Resolver

    # def searchPerson_v2(searchTerm:, exact:, limit:, offset:, email_search:)
    #   # Your search logic goes here
    #   # For example, if you have a Person model:
    #   binding.pry
    #   persons = Person.search(searchTerm, exact, limit, offset, email_search)
    #   persons
    # end

    # field :search_person_v2, Types::SearchPersonV2Type, null: false do
    #   argument :search_term, String, required: true
    #   argument :limit, Int, required: false
    #   argument :offset, Int, required: false
    #   argument :exact, Boolean, required: false
    #   argument :email_search, Boolean, required: false
    # end

    # def search_person_v2(search_term:, limit: 20, offset: 0, exact: false, email_search: true)
    #   # Your logic to fetch data based on the provided arguments
    #   # Replace this with your actual implementation
    #   # Example:
    #   # Contact.search(search_term, limit, offset, exact, email_search)
    #   # Company.search(search_term, limit, offset, exact, email_search)
    #   # User.search(search_term, limit, offset, exact, email_search)
    #   # This should return the data in the expected structure
    # end
  end
end
