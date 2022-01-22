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
    topic = Topic.new(name: results.first[:topic])
    topic.valid? ? topic.save! : topic = Topic.where(name: results.first[:topic]).first
    results.each_with_index do |result, index|
      result[:topic] = topic
      question = Question.new(result)
      question.subject = Subject.find(params[:subject_id])
      authorize question
      question.save! # save to get id

      # for all the images inside the folder, attach imagen.jpg as #{question.id}_n.jpg to question
      unless Dir["tmp/media/#{index}"].empty? # the question doesn't have a image
        Dir["tmp/media/#{index}/*"].sort.each do |fname|
          question.images.attach(io: File.open(fname), filename: fname.gsub(%r{tmp/media/./image}, "#{question.id}_"))
        end
      end

      # change the markdown in question that indicates the path of its images
      question.question.gsub!(%r{!\[]\(tmp//media/image}, "![](tmp//media/#{question.id}_")
      question.save!
    end

    FileUtils.rm_rf(Dir['tmp/media/*']) # delete local images
    redirect_to new_subject_question_path
  end
end
