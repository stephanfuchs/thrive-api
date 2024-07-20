module Resolvers
  class PostResolver < BaseResolver
    type Types::PostType, null: false
    argument :id, ID

    def resolve(id:)
      ::Company.find(id)
    end
  end
end
