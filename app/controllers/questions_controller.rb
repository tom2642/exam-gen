class QuestionsController < ApplicationController
  include Parseable
  include HtmlConvertable
  include ImagesAttachable
  include Objectifyable

  def index
    questions = policy_scope(Question).where(subject: params[:subject_id])
    @htmls = md_to_html(questions) # HtmlConvertable
  end

  def new
    skip_authorization
  end

  def create
    parsed_results = docx_to_md(params[:docx]) # Parseable

    # save every parsed results to db
    parsed_results.each_with_index do |result, index|
      # result[:topic], string -> Topic object
      objectify_topic(result) unless result[:topic].nil?
      question = Question.new(result)
      question.subject = Subject.find(params[:subject_id])
      authorize question
      question.save!
      attach_images(question, index)
    end

    FileUtils.rm_rf(Dir['tmp/media/*']) # delete local tmp images
    redirect_to dashboard_path
  end
end
