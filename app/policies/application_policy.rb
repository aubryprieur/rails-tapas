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
    false # Corrigé - ne s'appelle plus lui-même
  end

  def edit?
    update? # Corrigé - appelle update? au lieu de retourner false directement
  end

  def destroy?
    false
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
