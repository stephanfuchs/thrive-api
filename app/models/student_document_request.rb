# it will be used to list all types of document type
class StudentDocumentRequest < ApplicationRecord
  acts_as_paranoid

  has_many :document_request_entries, dependent: :destroy

end
