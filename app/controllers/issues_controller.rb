class IssuesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user, only: :destroy
  before_filter :has_valid_project?, only: :create

  def index
    @issues = Issue.paginate(page: params[:page], per_page: 10)
  end

  def create
      @issue = current_user.issues.build(params[:issue])
      @issue.status = "pending"
      @project = @issue.project
      flash[:success] = "Issue created!" if @issue.save
      render "projects/show"
  end

  def destroy
    project = @issue.project
    @issue.destroy
    redirect_to project
  end

  def solve
    @issue = Issue.find(params[:id])
    #TODO: can haz solver?
    #TODO: take it to the model
    @issue.who_is_solving = current_user
    @issue.status = "in progress"
    @issue.save

    respond_to do |format|
      format.html { redirect_to @issue.project }
      format.js
    end
  end

  def validate
    @issue = Issue.find(params[:id])
    #TODO: can haz validator?
    #TODO: take it to the model
    @issue.who_is_validating = current_user
    @issue.status = "validating"
    @issue.save

    respond_to do |format|
      format.html { redirect_to @issue.project }
      format.js
    end
  end

  def done_solving
    @issue = Issue.find(params[:id])
    #TODO: can haz solved?
    #TODO: take it to the model
    @issue.status = "waiting for validation"
    @issue.save

    respond_to do |format|
      format.html { redirect_to @issue.project }
      format.js
    end
  end

  def done_validating

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