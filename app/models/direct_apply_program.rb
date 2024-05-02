# frozen_string_literal: true

class DirectApplyProgram < PgApplicationRecord
  belongs_to :school

  scope :ucas, -> { where(is_ucas: true) }
end
