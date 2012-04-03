class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @issue = Issue.find(params[:comment][:issue_id])
    @comment = Comment.build_from(@issue, current_user.id, params[:comment][:body])
    if @comment.save
      flash[:success] = "Comment created!"
      redirect_to @issue.project
    else
      redirect_to root_path
    end
  end

end