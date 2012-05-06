class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @issue = Issue.find(params[:comment][:issue_id])
    @comment = Comment.build_from(@issue, current_user.id, params[:comment][:body])
    flash[:error] = t("comments.error_creating") if not @comment.save
    respond_to do |format|
      format.html { redirect_to @issue.project }
      format.js
    end
  end

end