class SubjectsController < ApplicationController
  def index
    @subjects = policy_scope(Subject)
    @new_subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)
    @subject.user = current_user
    authorize @subject
    @subject.save!
    redirect_to dashboard_path
  end

  def destroy
    @subject = Subject.find(params[:id])
    authorize @subject
    @subject.destroy
    redirect_to dashboard_path
  end

  private

  def subject_params
    params.require(:subject).permit(:grade, :name)
  end
end
