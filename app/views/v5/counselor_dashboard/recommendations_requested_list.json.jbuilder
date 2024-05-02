json.status do
  json.details do
    json.list(@recommendations_requested_list) do |student|
      json.user_id student.user_id
      json.first_name student.first_name
      json.last_name student.last_name
      json.recommendation_requests_size student.try(:recommendation_requests_size) || 0
      json.ca_teacher_eval_num @recommendations_required_count_hash[student.user_id]
    end

    json.count @total_count
  end
end
