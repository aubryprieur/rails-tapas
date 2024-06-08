class AdminPolicy < ApplicationPolicy
  def admin?
    user.present? && user.admin?
  end
end
