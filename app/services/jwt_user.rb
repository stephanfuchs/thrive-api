class JwtUser
  attr_reader :user_object

  def initialize(user_object)
    @user_object = user_object
  end

  def call
    generate_role_methods
    user_object ? self : nil
  end

  private

  # INFO: (Stephan) create .admin?, .manager? and .member? methods
  def generate_role_methods
    user_groups = Array(user_object&.dig(0, 'cognito:groups'))
    user_groups.each do |role|
      self.class.send(:define_method, "#{role.downcase}?") do
        user_groups.include?(role)
      end
    end
  end

  # INFO: (Stephan) maybe a of a rough approach
  def method_missing(method_name, *arguments, &block)
    false
  end
end
