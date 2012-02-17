class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @projects = @user.projects.paginate(page: params[:page])
  end

  def index
    @users = User.paginate(page: params[:page])
  end
end