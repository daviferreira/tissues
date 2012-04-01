class UsersController < ApplicationController
  before_filter :authenticate_user!, only: [:destroy_avatar]
  before_filter :correct_user, only: [:destroy_avatar]

  def show
    @user = User.find(params[:id])
    @projects = @user.projects.paginate(page: params[:page])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy_avatar
    @user = User.find(params[:id])
    @user.update_attributes(:avatar => nil)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless @user == current_user
    end

end