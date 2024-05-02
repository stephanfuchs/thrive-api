json.status do
  json.details do
    json.list(@list_data) do |student|
      json.user_id student.user_id
      json.first_name student.first_name
      json.last_name student.last_name
      json.document_completion_status student.document_completion_status
      json.no_of_applications @no_of_applications_hash[student.user_id] || 0
    end

    json.count @total_count
  end
end
