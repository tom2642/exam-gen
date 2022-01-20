class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where
    end
  end

  def create?
    true
  end
end
