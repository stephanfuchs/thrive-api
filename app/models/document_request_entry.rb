# it will take care of any request for document either general or application
# based
class DocumentRequestEntry < ApplicationRecord
  acts_as_paranoid

  enum request_status: %i[requested cancelled submitted approved sent]

end
