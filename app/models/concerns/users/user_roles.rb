module Users
  module UserRoles
    extend ActiveSupport::Concern

    USER_TYPES = %w[student mentor guardian admin system]

    def convert_from_bit_mask(bit_mask, reference)
      unless reference.is_a? Array
        reference = [reference]
      end

      reference.reject do |r|
        ((bit_mask.to_i || 0) & 2**reference.index(r)).zero?
      end
    end

    def get_user_type
      convert_from_bit_mask(self.user_type_mask, USER_TYPES)
    end

    def admin?
      get_user_type.include?('admin')
    end

    def mentor?
      get_user_type.include?('mentor') && mentor.try(:is_mentor)
    end

    def student?
      get_user_type.include?('student')
    end
  end
end
