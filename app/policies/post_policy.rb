class PostPolicy < ApplicationPolicy

  def update?
    return true if admin?
  end

  def destroy?
    return true if admin?
  end

  def new?
    return true if admin?
  end

  private

    def admin
      record.user_id == admin?
    end

    def admin?
      admin_types.include?(user.type)
    end

end
