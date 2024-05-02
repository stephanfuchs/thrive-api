json.status do
  json.details do
    json.list(@students) do |student|
      json.id student.user_id
      json.first_name student.first_name
      json.last_name student.last_name
      json.ferpa_status student.ferpa_status.titleize
      json.applying_to_ca student.user_id.in?(@applying_to_ca_student_ids)
    end

    json.count @total_count
  end
end
