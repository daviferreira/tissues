class IssuesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user, only: :destroy
  before_filter :has_valid_project?, only: :create

  def index
    @issues = Issue.paginate(page: params[:page], per_page: 10)
  end

  def create
      issue = current_user.issues.build(params[:issue])
      flash[:success] = "Issue created!" if issue.save
      redirect_to issue.project
  end

  def destroy
    project = @issue.project
    @issue.destroy
    redirect_to project
  end
  
  private

      def correct_user
        @issue = current_user.issues.find_by_id(params[:id])
        redirect_to root_path if @issue.nil?
      end
      
      def has_valid_project?
        project_id = params[:issue][:project_id]
        redirect_to root_path if project_id.nil? or not Project.find(project_id)
      end
  
end