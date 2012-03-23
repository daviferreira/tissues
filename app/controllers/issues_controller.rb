class IssuesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user, only: :destroy

  def create
    project_id = params[:issue][:project_id]
    if project_id.nil?
      redirect_to root_path
    else
      @issue = current_user.issues.build(params[:issue])
      @project = Project.find(project_id)
      if @issue.save
        flash[:success] = "Issue created!"
        render "projects/show"
      else
        if @project.nil?
          redirect_to root_path 
        else
          render "projects/show"
        end
      end
    end
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
  
end