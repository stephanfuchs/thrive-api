module Types
  class CompanyType < GraphQL::Schema::Object
    field :type, String, null: true
    field :id, ID, null: true
    field :name, String, null: true
  end
end
