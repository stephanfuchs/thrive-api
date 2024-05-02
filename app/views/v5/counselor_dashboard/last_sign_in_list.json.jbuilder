json.status do
  json.details do
    json.list(@list_data.list) do |list_entry|
      json.extract! list_entry, :id, :first_name, :last_name, :preferred_name, :last_login, :graduation_year
    end

    json.count @list_data.count
  end
end
