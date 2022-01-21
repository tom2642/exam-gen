class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:subject).where(subject: { user: user })
    end
  end

  def create?
    true
  end
end
