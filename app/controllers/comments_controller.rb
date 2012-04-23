class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @issue = Issue.find(params[:comment][:issue_id])
    @comment = Comment.build_from(@issue, current_user.id, params[:comment][:body])
    if @comment.save
      flash[:success] = t("comments.comment_created")
    else
      flash[:error] = t("comments.error_creating")
    end
    respond_to do |format|
      format.html { redirect_to @issue.project }
      format.js
    end
  end

end