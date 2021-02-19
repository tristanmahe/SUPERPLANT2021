class RentalPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    true
  end

  def show?
    true
  end

  def accept?
    record.plant.user == user
  end
  
  def deny?
    accept?
  end
end
