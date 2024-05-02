# it will be used to list all types of document type
class DocumentType < ApplicationRecord
  acts_as_paranoid

  enum delivery_type: %I[parchment common_app nacac tenant mail direct_apply ucas]

  has_many :documents

  NOT_INCLUDED_DOCUMENT_TYPES = %w[common_app tenant]
  NOT_INCLUDED_CHECKLIST_TYPES = [26, 28, 31, 32, 49, 41]
  INCLUDED_DOCUMENT_TYPE_IDS =
    [25, 19, 20, 22, 21, 23, 24, 27, 29, 8, 60]

  CDOCS_UPLOADER_ID_ORDER = [20, 22, 21, 24, 23, 19, 27, 29, 25, 8]

  SCHOOL_PROFILE_TYPE_ID = 29
  FINAL_TRANSCRIPT_ID = 23
  MID_YEAR_TRANSCRIPT = 22
  INITIAL_TRANSCRIPT = 20

  REQUIRED_DIRECT_APPLY_DOCUMENT_TYPE_IDS = [Constants::DocumentType::ENTRIES[:passport][:id]]

  TRANSCRIPT_IDS = [41, 20, 21, 23, 24, 42, 43, 44]

  INITIAL_DOC_IDS = [20, 19, 27, 29, 25, 1, 51, 50]
  MID_YEAR_DOC_IDS = [22, 21, 11, 7]
  OTHER_DOC_IDS = [24, 8]
  FINAL_DOC_IDS = [23, 15]
  UCAS_REFERENCE_LETTER_ID = 59
end
