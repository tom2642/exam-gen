class QuestionsController < ApplicationController
  include Parseable
  include HtmlConvertable
  include ImagesAttachable
  include Objectifyable
  include DocxConvertable

  def index
    questions = policy_scope(Question).where(subject: params[:subject_id])
    @topics = questions.map { |question| question.topic[:name] }.uniq
    @questions_and_htmls = md_to_html(questions) # HtmlConvertable
  end

  def new
    @subject = Subject.find(params[:subject_id])
    authorize @subject
  end

  def create
    parsed_results = docx_to_md(params[:docx], params[:billy]) # Parseable
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

  def download_docx
    selected_questions = []
    params[:question_ids].each do |id|
      selected_question = Question.find(id)
      authorize selected_question
      selected_questions.push(selected_question)
    end
    send_docx(selected_questions)
  end

  def download_demo
    skip_authorization
    send_file 'public/examgen_demo.docx'
  end
end
