json.status do
  json.details do
    json.count @list_data.count
    json.list(@list_data.list) do |list_entry|
      json.extract! list_entry, :id, :first_name, :last_name, :preferred_name, :graduation_year
      json.status list_entry['assesments_states'][@list_data.assesment_type]
    end
    json.assesment_type @list_data.assesment_type
  end
end
