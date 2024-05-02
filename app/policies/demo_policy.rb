class DemoPolicy < ApplicationPolicy
  # _record is :demo
  def initialize(user, _record)
    @user = user
  end

  def index?
    true
  end

  def show?
    user.admin?
  end

  def demo?
    true
  end
end
