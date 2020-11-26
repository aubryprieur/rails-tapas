class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    new?
  end

  def new?
    false
  end

  def update?
    update?
  end

  def edit?
    update?
  end

  def destroy?
    destroy?
  end

  def admin_types
    ['AdminUser']
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
