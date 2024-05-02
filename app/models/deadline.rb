class Deadline < PgApplicationRecord
  
  class << self
    def graduation_year_definition
      application_year_definition + 1
    end

    def application_year_definition
      current_time = Time.now
      # Verified with Jen already and the logic is:
      # current_month <= July = time.now - 1.year
      # current_month > July = time.now.year
      if current_time.month > 7
        current_time.year
      else
        current_time.year - 1
      end
    end
  end
end
