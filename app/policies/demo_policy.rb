class DemoPolicy < ApplicationPolicy
  def initialize(user, _record)
    super(user, _record)
    @user = user
  end

  def index?
    true
  end

  def show?
    user.admin?
  end

  def demo?
    user.member?
  end
end
