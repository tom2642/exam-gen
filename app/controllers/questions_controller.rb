class QuestionsController < ApplicationController
  include Parseable

  def index
    @questions = policy_scope(Question).where(subject: params[:subject_id])
  end

  def new
    skip_authorization
  end

  def create
    results = parse(params[:docx])
    results.each do |result|
      question = Question.new(result)
      authorize question
      # save question
      # image1.jpg -> #{question.id}_1.jpg
      # in question.question, gsub image1.jpg -> #{question.id}_1.jpg
      # save question
    end

    redirect_to new_subject_question_path
  end
end
