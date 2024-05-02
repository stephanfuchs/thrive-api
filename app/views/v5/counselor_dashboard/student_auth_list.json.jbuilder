json.status do
  json.details do
    json.list(@students) do |student|
      json.name student.f_name
      json.date_time student.created_at
    end

    json.count @total_count
  end
end
