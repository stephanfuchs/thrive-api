# frozen_string_literal: true

module Constants
  class DirectProgramApplication
    SIMPLE_UCAS_LIMIT = 5
    EXPLORE_RESULT_MAPPING = {
      'Draft'                 => :result_pending,
      'Pending'               => :result_submitted,
      'Conditional Offer'     => :result_conditional_offer,
      'Unconditional Offer'   => :result_unconditional_offer,
      'Denied'                => :result_denied,
      'Waitlisted'            => :result_waitlisted,
      'Withdrawn'             => :result_withdrawn,
      'Deferred'              => :result_deferred,
      'Not Interested'        => :result_not_interested,
      'Accepted'              => :result_accepted,
      'Accepted Conditional'  => :result_accepted_conditional,
      'Enrolled'              => :result_accepted
    }
    RESULTS = EXPLORE_RESULT_MAPPING.values.uniq
    EXPLORE_STATUS_MAPPING = {
      'to_review'                     => :submitted_to_cialfo,
      'reviewing'                     => :reviewing,
      'submitted_to_university'       => :submitted_to_university,
      'pending_info'                  => :pending_info,
      'pending_decision'              => :pending_decision,
      'deposit_paid'                  => :deposit_paid,
      'cas_issued'                    => :cas_issued,
      'visa_processing'               => :visa_processing,
      'visa_approved'                 => :visa_approved,
      'visa_rejected'                 => :visa_rejected,
      'fees_paid'                     => :fees_paid,
      'new'                           => :draft,
      'pending_letter'                => :pending_letter,
      'closed'                        => :closed,
      'withdrawn'                     => :withdrawn,
      'deposit_pending'               => :deposit_pending,
      'post_acceptance_statuses'      => :post_acceptance_statuses,
      'information_required'          => :information_required,
      'submitted_to_counselor'        => :submitted_to_counselor,
      'revision_required'             => :revision_required,
      'intake_closed'                 => :intake_closed,
      'form_not_started'              => :form_not_started,
      'form_inprogress'               => :form_inprogress,
      'form_completed'                => :form_completed,
      'revision_requested_by_cialfo'  => :revision_requested_by_cialfo
    }
    INITIAL_SUBMIT_EXPLORE_STATUSES = ['submitted_to_university', 'submitted_to_cialfo']
    PRE_SUBMIT_EXPLORE_STATUSES = ['revision_required', 'form_not_started', 'form_inprogress', 'form_completed', 'revision_requested_by_cialfo', 'draft', 'submitted_to_counselor']
    EXPLORE_STATUSES            = EXPLORE_STATUS_MAPPING.values.uniq
    EXPLORE_WITHDRAW_STATUS     = 'Withdrawn'
    SUBMIT_APP_LIMIT            = 10
    UCAS_MEDICAL_PROGRAM_LIMIT  = 4
    OXBRIDGE_SCHOOL_IDS         = [3000001, 3000000]
    MEDICAL_COURSE_CODE         = ['71A8', 'A100', 'A101', 'A102', 'A104', 'A106', 'A108', 'A10L', 'A110', 'A18L', 'A200', 'A201', 'A202', 'A204', 'A206', 'A208', 'A990', 'D100', 'D101', 'D102', 'D105', 'D108', 'D210']
    UNI_DECISION_TITLES         = {
      'conditional_offer'   => 'Conditional Offer',
      'unconditional_offer' => 'Unconditional Offer',
      'denied'              => 'Unsuccessful'
    }
    UNI_DECISION_RESULTS = ['result_denied', 'result_conditional_offer', 'result_unconditional_offer']
    EXPLORE_CHOICE_MAPPING = {
      'firm' => :firm,
      'insurance' => :insurance,
      'not_firm_insurance' => :declined
    }
  end
end
