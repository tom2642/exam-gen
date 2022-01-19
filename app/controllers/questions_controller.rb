class QuestionsController < ApplicationController
  def index
    @abc = Question.new
    authorize @abc
  end

  def new
    @abc = Question.new
    authorize @abc
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
