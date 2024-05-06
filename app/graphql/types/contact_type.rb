module Types
  class ContactType < GraphQL::Schema::Object
    field :is_primary, Boolean, null: true
    field :contact_value, String, null: true
    field :contact_type, String, null: true
    field :id, ID, null: true
  end
end
