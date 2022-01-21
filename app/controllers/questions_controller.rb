class QuestionsController < ApplicationController
  def index
    @questions = policy_scope(Question).where(subject: params[:subject_id])
  end

  def new
    skip_authorization
  end

  def create
    @question = Question.new
    authorize @question

    redirect_to new_subject_question_path
  end
end
