# frozen_string_literal: true

module Constants
  class DocumentType
    INITIAL_DOC = 'Initial Documents'
    MID_YEAR_DOC = 'Mid-year Documents'
    FINAL_DOC = 'Final Documents'
    COUNSELOR_DOC = 'Counselor Documents'
    TEACHER_DOC = 'Teacher Documents'
    STUDENT_DOC = 'Student Documents'
    OPTIONAL_DOC = 'Optional Documents'
    TRANSCRIPT = 'Transcripts'
    OTHER_DOC = 'Other Documents'
    MAIL = ::DocumentType.delivery_types[:mail]
    NACAC = ::DocumentType.delivery_types[:nacac]
    PARCHMENT = ::DocumentType.delivery_types[:parchment]
    COMMON_APP = ::DocumentType.delivery_types[:common_app]
    TENANT = ::DocumentType.delivery_types[:tenant]
    UCAS = ::DocumentType.delivery_types[:ucas]
    SCHOOL_PROFILE_TYPE = 'School Profile & Information'
    # DIRECT APPLY DOCUMENT TYPES
    DIRECT_APPLY = ::DocumentType.delivery_types[:direct_apply]
    PASSPORT = 'Passport'
    ENGLISH_LANG_CERTIFICATES = 'English Language certificates'
    HIGH_SCHOOL_TRANSCRIPT = 'High School Transcript'
    ADDITIONAL_TRANSCRIPT = 'Additional Transcript'
    GOVT_VISA = 'Government Visa'
    OTHER_DIRECT_APPLY_DOCUMENTS = 'Other Documents'
    EXPLORE_RESULT_DOCUMENT = 'Explore Result Document'
    EXPLORE_OTHER_DOCUMENT_TYPE_ID = 6
    STUDENT_TRANSCRIPT_TYPES = [20, 22, 23, 24]
    UCAS_REFERENCE_LETTER = 'UCAS Reference Letter'
    UCAS_REFERENCE_LETTER_TITLE = 'Letter of Reference - UCAS'
    UCAS_PREDICTED_GRADES_TITLE = 'Predicted Grades'

    VALID_APPLICATION_DOCUMENT_TYPE = %w[ucas_application_file ucas_offer_letter cas_statement]

    # NOTE: When updating document_type name Uploaders::Seed should also be executed
    # NOTE: When updating document_type name DocumentTypes::Seed should also be executed
    ENTRIES = HashWithIndifferentAccess.new(
      common_app_teacher_evaluation: {
        id: 51,
        title: 'Common App Teacher Evaluation',
        check_list_type: INITIAL_DOC,
        document_type: TEACHER_DOC,
        delivery_type: COMMON_APP,
        reference_id: 51
      },
      common_app_teacher_evaluation_retired: {
        id: 18,
        title: 'Common App Teacher Evaluation (Retired)',
        check_list_type: TEACHER_DOC,
        document_type: TEACHER_DOC,
        delivery_type: COMMON_APP,
        reference_id: 18
      },
      letter_of_recommendation: {
        id: 19,
        title: 'Letter of Recommendation',
        check_list_type: INITIAL_DOC,
        document_type: TEACHER_DOC,
        delivery_type: PARCHMENT,
        reference_id: 40
      },
      letter_of_recommendation_teacher: {
        id: 40,
        title: 'Letter of Recommendation - Teacher',
        check_list_type: TEACHER_DOC,
        document_type: TEACHER_DOC,
        delivery_type: PARCHMENT,
        reference_id: 40
      },
      common_app_mid_year_report: {
        id: 11,
        title: 'Common App Mid-year Report',
        check_list_type: MID_YEAR_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: COMMON_APP,
        reference_id: 11
      },
      nacac_mid_year_report: {
        id: 12,
        title: 'NACAC Mid-year Report',
        check_list_type: MID_YEAR_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: NACAC,
        reference_id: 12
      },
      secondary_school_report_mid_year: {
        id: 31,
        title: 'Secondary School Report - Midyear',
        check_list_type: MID_YEAR_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: MAIL,
        reference_id: 25
      },
      common_app_final_report: {
        id: 15,
        title: 'Common App Final Report',
        check_list_type: FINAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: COMMON_APP,
        reference_id: 15
      },
      secondary_school_report_final: {
        id: 32,
        title: 'Secondary School Report - Final',
        check_list_type: FINAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: MAIL,
        reference_id: 25
      },
      common_app_optional_report: {
        id: 7,
        title: 'Common App Optional Report',
        check_list_type: MID_YEAR_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: COMMON_APP,
        reference_id: 7
      },
      secondary_school_report_optional: {
        id: 33,
        title: 'Secondary School Report - Optional',
        check_list_type: OPTIONAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: MAIL,
        reference_id: 25
      },
      apostille_certificate: {
        id: 34,
        title: 'Apostille Certificate',
        check_list_type: OPTIONAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: MAIL,
        reference_id: 34
      },
      application: {
        id: 35,
        title: 'Application',
        check_list_type: OPTIONAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: MAIL,
        reference_id: 35
      },
      international_school_supplement: {
        id: 36,
        title: 'International School Supplement',
        check_list_type: OPTIONAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: MAIL,
        reference_id: 36
      },
      other: {
        id: 8,
        title: 'Other',
        check_list_type: OTHER_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: PARCHMENT,
        reference_id: 8
      },
      resume: {
        id: 37,
        title: 'Resume',
        check_list_type: OPTIONAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: MAIL,
        reference_id: 37
      },
      change_explanation: {
        id: 38,
        title: 'Change Explanation',
        check_list_type: OPTIONAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: MAIL,
        reference_id: 38
      },
      fee_waiver: {
        id: 39,
        title: 'Fee Waiver',
        check_list_type: OPTIONAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: MAIL,
        reference_id: 39
      },
      grade_report: {
        id: 9,
        title: 'Grade Report',
        check_list_type: OPTIONAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: MAIL,
        reference_id: 9
      },
      current_year_courses: {
        id: 49,
        title: 'Current Year Courses',
        check_list_type: INITIAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: COMMON_APP,
        reference_id: 49
      },
      counselor_recommendation: {
        id: 50,
        title: 'Counselor Recommendation',
        check_list_type: INITIAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: COMMON_APP,
        reference_id: 50
      },
      transcript: {
        id: 41,
        title: 'Transcript',
        check_list_type: INITIAL_DOC,
        document_type: TRANSCRIPT,
        delivery_type: PARCHMENT,
        reference_id: 41
      },
      initial_transcript: {
        id: 20,
        title: 'Initial transcript',
        check_list_type: INITIAL_DOC,
        document_type: TRANSCRIPT,
        delivery_type: MAIL,
        reference_id: 41
      },
      optional_transcript: {
        id: 21,
        title: 'Optional Transcript',
        check_list_type: MID_YEAR_DOC,
        document_type: TRANSCRIPT,
        delivery_type: MAIL,
        reference_id: 41
      },
      mid_year_transcript: {
        id: 22,
        title: 'Mid-Year transcript',
        check_list_type: MID_YEAR_DOC,
        document_type: TRANSCRIPT,
        delivery_type: MAIL,
        reference_id: 41
      },
      transcript_final: {
        id: 23,
        title: 'Transcript - Final',
        check_list_type: FINAL_DOC,
        document_type: TRANSCRIPT,
        delivery_type: PARCHMENT,
        reference_id: 23
      },
      transfer_transcript: {
        id: 24,
        title: 'Transfer Transcript',
        check_list_type: OTHER_DOC,
        document_type: TRANSCRIPT,
        delivery_type: PARCHMENT,
        reference_id: 24
      },
      transfer_transcript_1: {
        id: 42,
        title: 'Transfer transcript 1',
        check_list_type: TRANSCRIPT,
        document_type: TRANSCRIPT,
        delivery_type: MAIL,
        reference_id: 42
      },
      transfer_transcript_2: {
        id: 43,
        title: 'Transfer transcript 2',
        check_list_type: TRANSCRIPT,
        document_type: TRANSCRIPT,
        delivery_type: MAIL,
        reference_id: 42
      },
      transfer_transcript_3: {
        id: 44,
        title: 'Transfer transcript 3',
        check_list_type: TRANSCRIPT,
        document_type: TRANSCRIPT,
        delivery_type: MAIL,
        reference_id: 42
      },
      degree_certificate: {
        id: 45,
        title: 'Degree Certificate',
        check_list_type: TRANSCRIPT,
        document_type: TRANSCRIPT,
        delivery_type: MAIL,
        reference_id: 45
      },
      diploma: {
        id: 46,
        title: 'Diploma',
        check_list_type: TRANSCRIPT,
        document_type: TRANSCRIPT,
        delivery_type: MAIL,
        reference_id: 46
      },
      enrollment_certificate: {
        id: 47,
        title: 'Enrollment Certificate',
        check_list_type: TRANSCRIPT,
        document_type: TRANSCRIPT,
        delivery_type: MAIL,
        reference_id: 47
      },
      professional_certificate: {
        id: 48,
        title: 'Professional Certificate',
        check_list_type: TRANSCRIPT,
        document_type: TRANSCRIPT,
        delivery_type: MAIL,
        reference_id: 48
      },
      common_app_school_report: {
        id: 1,
        title: 'Common App School Report',
        check_list_type: INITIAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: COMMON_APP,
        reference_id: 1
      },
      nacac_school_report: {
        id: 2,
        title: 'NACAC School Report',
        check_list_type: INITIAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: NACAC,
        reference_id: 2
      },
      secondary_school_report: {
        id: 25,
        title: 'Secondary School Report',
        check_list_type: INITIAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: PARCHMENT,
        reference_id: 25
      },
      secondary_school_report_initial: {
        id: 26,
        title: 'Secondary School Report - Initial',
        check_list_type: INITIAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: MAIL,
        reference_id: 25
      },
      letter_of_recommendation_counselor: {
        id: 27,
        title: 'Letter of Recommendation - Counselor',
        check_list_type: INITIAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: PARCHMENT,
        reference_id: 27
      },
      international_leaving_results: {
        id: 28,
        title: 'International Leaving Results',
        check_list_type: INITIAL_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: MAIL,
        reference_id: 28
      },
      school_profile: {
        id: 29,
        title: 'School Profile',
        check_list_type: INITIAL_DOC,
        document_type: SCHOOL_PROFILE_TYPE,
        delivery_type: TENANT,
        reference_id: 29
      },
      school_report: {
        id: 30,
        title: 'School Report',
        check_list_type: INITIAL_DOC,
        document_type: SCHOOL_PROFILE_TYPE,
        delivery_type: TENANT,
        reference_id: 30
      },
      passport: {
        id: 52,
        title: PASSPORT,
        document_type: STUDENT_DOC,
        check_list_type: STUDENT_DOC,
        delivery_type: DIRECT_APPLY,
        reference_id: 52
      },
      english_lang_certificates: {
        id: 53,
        title: ENGLISH_LANG_CERTIFICATES,
        document_type: STUDENT_DOC,
        check_list_type: STUDENT_DOC,
        delivery_type: DIRECT_APPLY,
        reference_id: 53
      },
      high_school_transcript: {
        id: 54,
        title: HIGH_SCHOOL_TRANSCRIPT,
        document_type: STUDENT_DOC,
        check_list_type: STUDENT_DOC,
        delivery_type: DIRECT_APPLY,
        reference_id: 54
      },
      additional_transcript: {
        id: 55,
        title: ADDITIONAL_TRANSCRIPT,
        document_type: STUDENT_DOC,
        check_list_type: STUDENT_DOC,
        delivery_type: DIRECT_APPLY,
        reference_id: 55
      },
      govt_visa: {
        id: 56,
        title: GOVT_VISA,
        document_type: STUDENT_DOC,
        check_list_type: STUDENT_DOC,
        delivery_type: DIRECT_APPLY,
        reference_id: 56
      },
      other_direct_apply_documents: {
        id: 57,
        title: OTHER_DIRECT_APPLY_DOCUMENTS,
        document_type: STUDENT_DOC,
        check_list_type: STUDENT_DOC,
        delivery_type: DIRECT_APPLY,
        reference_id: 57
      },
      explore_result_documents: {
        id: 58,
        title: EXPLORE_RESULT_DOCUMENT,
        document_type: STUDENT_DOC,
        check_list_type: STUDENT_DOC,
        delivery_type: DIRECT_APPLY,
        reference_id: 58
      },
      ucas_reference_letter: {
        id: 59,
        title: UCAS_REFERENCE_LETTER_TITLE,
        document_type: UCAS_REFERENCE_LETTER,
        check_list_type: INITIAL_DOC,
        delivery_type: UCAS,
        reference_id: 59
      },
      predicted_grades: {
        id: 60,
        title: UCAS_PREDICTED_GRADES_TITLE,
        document_type: TRANSCRIPT,
        check_list_type: INITIAL_DOC,
        delivery_type: PARCHMENT,
        reference_id: 8
      },
      common_app_optional_report2: {
        id: 61,
        title: 'Common App Optional Report 2',
        check_list_type: MID_YEAR_DOC,
        document_type: COUNSELOR_DOC,
        delivery_type: COMMON_APP,
        reference_id: 61
      },
      ucas_student_application_file: {
        id: 62,
        title: 'Ucas Student Application File',
        check_list_type: nil,
        document_type: 'UcasApplicationFile',
        delivery_type: nil,
        reference_id: 62
      },
      ucas_application_offer_letter: {
        id: 63,
        title: 'Ucas Application Offer Letter',
        check_list_type: nil,
        document_type: 'UcasOfferLetter',
        delivery_type: nil,
        reference_id: 63
      },
      application_cas_statement: {
        id: 64,
        title: 'Application Cas Statement',
        check_list_type: nil,
        document_type: 'ApplicationCasStatement',
        delivery_type: nil,
        reference_id: 64
      },
    )

    SCHOOL_REPORTS =
    %i[other initial_transcript transfer_transcript transcript].map do |key|
      ENTRIES[key][:id]
    end
    RECOMMENDATION = ENTRIES[:letter_of_recommendation][:id]
    COUNSELOR_RECOMMENDATION = ENTRIES[:letter_of_recommendation_counselor][:id]
    CA_TEACHER_EVALUATION = ENTRIES[:common_app_teacher_evaluation][:id]
    CA_COUNSELOR_RECOMMENDATION = ENTRIES[:counselor_recommendation][:id]
    SCHOOL_PROFILE = ENTRIES[:school_profile][:id]
    MIDYEAR_REPORT = ENTRIES[:mid_year_transcript][:id]
    FINAL_REPORT = ENTRIES[:transcript_final][:id]
    OPTIONAL_REPORT = ENTRIES[:optional_transcript][:id]
    RESUME = ENTRIES[:resume][:id]
    OPTIONAL_REPORT_2_ID = ENTRIES[:common_app_optional_report2][:id]
    PREDICTED_GRADES = ENTRIES[:predicted_grades][:id]
    UCAS_APPLICATION_FILE = ENTRIES[:ucas_student_application_file][:id]
    UCAS_OFFER_LETTER = ENTRIES[:ucas_application_offer_letter][:id]
    CAS_STATEMENT = ENTRIES[:application_cas_statement][:id]
  end
end
