json.status do
  json.details do
    json.list(@list_data.list) do |list_entry|
      json.extract! list_entry, :id, :first_name, :last_name, :preferred_name, :last_registration_sent_at, :last_login, :graduation_year
    end
    json.registered @list_data.registered
  end
end
