json.status do
  json.details do
    json.list(@direct_program_applications) do |direct_program_application|
      json.student_id direct_program_application.student_id
      json.student_name direct_program_application.f_name
      json.image_logo @direct_apply_programs_hash[direct_program_application.direct_apply_program_id]&.image_logo || ''
      json.school_name @direct_apply_programs_hash[direct_program_application.direct_apply_program_id]&.name
    end

    json.count @total_count
  end
end
