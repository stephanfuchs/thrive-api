module Types
  class SearchPersonV2Type < GraphQL::Schema::Object
    field :contacts, [Types::ContactType], null: true
    field :company, Types::CompanyType, null: true
    field :id, ID, null: true
    field :first_name, String, null: true
    field :last_name, String, null: true
  end
end
