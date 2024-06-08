class PostPolicy < ApplicationPolicy
  def show?
    true # Autoriser tout le monde à voir les détails d'un post
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def new?
    admin?
  end

  def create?
    admin?
  end

  private

  def admin?
    user.present? && admin_types.include?(user.type)
  end
end
