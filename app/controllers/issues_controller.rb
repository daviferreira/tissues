class IssuesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user, only: [:edit, :update, :destroy]
  before_filter :has_valid_project?, only: :create

  def create
    @issue = current_user.issues.build(params[:issue])
    if @issue.valid?
      @issue.status = "pending"
      @issue.save
    else
      flash[:error] = t("issues.error_creating")
    end
    respond_to do |format|
      format.html { redirect_to @issue.project }
      format.js
    end
  end

  def details
    @issue = Issue.find(params[:id])
    respond_to do |format|
      format.html { redirect_to @issue }
      format.js
    end
  end

  def edit
    @issue = Issue.find(params[:id])
    respond_to do |format|
      format.html { redirect_to @issue.project }
      format.js
    end
  end

  def destroy
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to @issue.project }
      format.js
    end
  end

  def solve
    @issue = Issue.find(params[:id])

    if @issue.can_be_solved
      @issue.who_is_solving = current_user
      @issue.status = "in progress"
      @issue.save
    end

    respond_to do |format|
      format.html { redirect_to @issue.project }
      format.js
    end
  end

  def done_solving
    @issue = Issue.find(params[:id])
    if @issue.can_be_finished_by(current_user, "solving")
      @issue.status = "waiting for validation"
      @issue.save
    end

    respond_to do |format|
      format.html { redirect_to @issue.project }
      format.js
    end
  end

  def abandon_solving
    @issue = Issue.find(params[:id])
    if @issue.can_be_finished_by(current_user, "solving")
      @issue.who_is_solving = nil
      @issue.status = "pending"
      @issue.save
    end
    respond_to do |format|
      format.html { redirect_to @issue.project }
      format.js
    end
  end

  def validate
    @issue = Issue.find(params[:id])
    if @issue.can_be_validated_by(current_user)
      @issue.who_is_validating = current_user
      @issue.status = "validating"
      @issue.save
    end

    respond_to do |format|
      format.html { redirect_to @issue.project }
      format.js
    end
  end

  def abandon_validation
    @issue = Issue.find(params[:id])
    if @issue.can_be_finished_by(current_user, "validating")
      @issue.who_is_validating = nil
      @issue.status = "waiting for validation"
      @issue.save
    end
    respond_to do |format|
      format.html { redirect_to @issue.project }
      format.js
    end
  end

  def done_validating
    @issue = Issue.find(params[:id])
    if @issue.can_be_finished_by(current_user, "validating")
      @issue.status = params[:status]
      @issue.save
    end
    respond_to do |format|
      format.html { redirect_to @issue.project }
      format.js
    end
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