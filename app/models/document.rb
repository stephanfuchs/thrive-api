# it will take care of all student documents
class Document < ApplicationRecord
  acts_as_paranoid

  attr_accessor :dont_attach_to_documentable

  PDF_CONTENT_TYPES = %w[application/pdf text/pdf]
  DA_FILE_TYPES     = %w[application/pdf text/pdf image/jpeg]

  belongs_to :document_type
  belongs_to :documentable, polymorphic: true

  has_and_belongs_to_many :students, -> { distinct }

  def tenant
    Tenant.current
  end
end
