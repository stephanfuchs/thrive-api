# frozen_string_literal: true

class DocumentDirectProgramApplication < ApplicationRecord

  belongs_to :direct_program_application
  belongs_to :document

  enum status: %i[assigned started uploading uploaded sent rejected]

  default_scope { where(explore_result_id: nil) }
end
