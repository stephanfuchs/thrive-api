# frozen_string_literal: true

module Constants
  # Constants::Assessments
  class Assessments
    PERSONALITY_ID = 104
    LEARNING_AND_PRODUCTIVITY_ID = 101
    PERSONALITY_INTELLIGENCES_ID = 100
    MAX_TAKE_COUNT = 6

    # Constants::Assessments::AVAILABLE
    # https://cialfo.atlassian.net/browse/CC-7955
    # changed personality_skills back to college scope
    AVAILABLE = [
      {
        id: PERSONALITY_ID,
        title: 'AchieveWorks® Personality',
        previous_title: 'Do What You Are',
        description_locale_key: 'personality_description',
        student_search_key: 'personality'
      },
      {
        id: LEARNING_AND_PRODUCTIVITY_ID,
        title: 'AchieveWorks® Learning & Productivity',
        previous_title: 'Learning Style Inventory',
        description_locale_key: 'learning_and_productivity_description',
        student_search_key: 'learning_and_productivity'
      },
      {
        id: PERSONALITY_INTELLIGENCES_ID,
        title: 'AchieveWorks® Personality Intelligences',
        previous_title: 'Multiple Intelligences',
        description_locale_key: 'personality_intelligences_description',
        student_search_key: 'personality_intelligences'
      }
    ]
  end
end
