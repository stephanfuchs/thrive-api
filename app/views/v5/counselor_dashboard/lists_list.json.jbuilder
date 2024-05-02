json.status do
  json.details do
    json.list(@list_data.list) do |list_entry|
      json.extract! list_entry, :id, :first_name, :last_name, :preferred_name, :graduation_year
      json.count list_entry['lists_counts'][@list_data.list_type]
    end

    json.list_type @list_data.list_type
    json.count @list_data.count
  end
end
