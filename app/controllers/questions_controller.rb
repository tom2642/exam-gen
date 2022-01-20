class QuestionsController < ApplicationController
  def index
    @questions = Subject.find(params(:subject_id)).questions
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
