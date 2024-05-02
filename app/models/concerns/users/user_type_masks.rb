module Users
  module UserTypeMasks
    extend ActiveSupport::Concern

    # INFO:
    #   the information comes from this command:
    #   `pp [*1..1124].map{|utm| [utm, User.new.send(:convert_from_bit_mask,utm, User::USER_TYPES)] }.uniq{|e| e[1]}.find_all{|e| e[1].length == 1 || e[1].exclude?('student') && e[1].exclude?('system') && e[1].length > 1};0`
    #
    #      1:  ["student"]
    #      2:  ["mentor"]
    #      4:  ["guardian"]
    #      6:  ["mentor", "guardian"]
    #      8:  ["admin"]
    #      10: ["mentor", "admin"]
    #      12: ["guardian", "admin"]
    #      14: ["mentor", "guardian", "admin"]
    #      16: ["system"]

    USER_TYPE_STUDENT                     = [1].freeze
    USER_TYPE_MENTOR                      = [2].freeze
    USER_TYPE_GUARDIAN                    = [4].freeze
    USER_TYPE_ADMIN                       = [8].freeze
    USER_TYPE_SYSTEM                      = [16].freeze
    USER_TYPE_ALL_MENTOR                  = [2, 6, 10, 14].freeze
    USER_TYPE_ALL_GUARDIAN                = [4, 6, 12, 14].freeze
    USER_TYPE_ALL_ADMIN                   = [8, 10, 12, 14].freeze

    USER_TYPE_ALL_ONLY_ADMIN              = [8, 12].freeze
    USER_TYPE_ALL_ONLY_MENTOR_ADMIN       = [10, 14].freeze
    USER_TYPE_ALL_ONLY_MENTOR             = [2, 6].freeze

    USER_TYPE_ALL_STUDENT_MENTOR_ADMIN    = (USER_TYPE_STUDENT      | USER_TYPE_ALL_MENTOR |
                                                                      USER_TYPE_ALL_ADMIN).freeze
    USER_TYPE_ALL_WITHOUT_SYSTEM          = (USER_TYPE_STUDENT      | USER_TYPE_ALL_MENTOR |
                                             USER_TYPE_ALL_GUARDIAN | USER_TYPE_ALL_ADMIN).freeze

    USER_TYPE_ALL_GUARDIAN_AND_ADMIN      = (USER_TYPE_ALL_GUARDIAN | USER_TYPE_ALL_ADMIN).freeze
    USER_TYPE_ALL_MENTOR_AND_ADMIN        = (USER_TYPE_ALL_MENTOR   | USER_TYPE_ALL_ADMIN).freeze
    USER_TYPE_ALL_MENTOR_AND_STUDENT      = (USER_TYPE_ALL_MENTOR   | USER_TYPE_STUDENT).freeze
    USER_TYPE_MENTOR_AND_GUARDIAN_MENTOR  = (USER_TYPE_ALL_MENTOR   - USER_TYPE_ALL_ADMIN).freeze
    USER_TYPE_TEAMMATE                    = (USER_TYPE_ALL_MENTOR   | USER_TYPE_ALL_ADMIN).freeze
    USER_TYPE_ALL_MENTOR_AND_ALL_GUARDIAN = (USER_TYPE_ALL_MENTOR   | USER_TYPE_ALL_GUARDIAN).freeze
    USER_TYPE_ALL_WITHOUT_GUARDIAN_SYSTEM = (USER_TYPE_ALL_GUARDIAN - USER_TYPE_ALL_WITHOUT_SYSTEM).freeze
  end
end
