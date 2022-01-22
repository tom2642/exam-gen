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
      question.subject = Subject.find(params[:subject_id])
      authorize question
      question.save! # save to get id
      Dir["tmp/media/*"].each do |fname| # image1.jpg -> #{question.id}_1.jpg
        question.images.attach(io: File.open(fname), filename: fname.gsub("image", "#{question.id}_"))
      end
      question.question.gsub!(%r{!\[]\(tmp/media/image}, 'image' => "#{question.id}_")
      question.choices.map! do |choice|
        choice.gsub(%r{!\[]\(tmp/media/image}, 'image' => "#{question.id}_")
      end
      question.save!
    end

    redirect_to new_subject_question_path
  end
end
