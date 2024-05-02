class CounselorDashboardPolicy < ApplicationPolicy
  def index?
    user.mentor? || user.admin?
  end
end
