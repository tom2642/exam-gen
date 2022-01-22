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
    results.each_with_index do |result, index|
      question = Question.new(result)
      question.subject = Subject.find(params[:subject_id])
      authorize question
      question.save! # save to get id
      unless Dir["tmp/media/#{index}"].empty?
        Dir["tmp/media/#{index}/*"].each do |fname| # image1.jpg -> #{question.id}_1.jpg
          question.images.attach(io: File.open(fname), filename: fname.gsub(%r{tmp/media/./image}, "#{question.id}_"))
        end
      end
      question.question.gsub!(%r{!\[]\(tmp//media/image}, "![](tmp//media/#{question.id}_")
      question.choices&.map! do |choice|
        choice.gsub(%r{!\[]\(tmp//media/image}, "![](tmp//media/#{question.id}_")
      end
      question.save!
    end

    redirect_to new_subject_question_path
  end
end
