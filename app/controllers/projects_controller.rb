class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @projects = Project.paginate(page: params[:page])
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = current_user.projects.build
  end
  
  def edit
    @project = current_user.projects.find_by_id(params[:id])
    redirect_to root_path if not @project
  end
  
  def create
    @project = current_user.projects.build(params[:project])
    if @project.save
      flash[:success] = "Project created!"
      redirect_to @project
    else
      render 'projects/new'
    end
  end
  
  def update
    @project = current_user.projects.find_by_id(params[:id])
    if not @project
      redirect_to root_path 
    elsif @project.update_attributes(params[:project])
      redirect_to @project, :flash => { :success => "Project updated." }
    else
      render 'edit'
    end
  end
  
  def destroy
    @project = current_user.projects.find_by_id(params[:id])
    if not @project
      redirect_to root_path
    else
      @project.destroy
      redirect_to projects_path, :flash => { :success => "Project destroyed." }
    end
  end
end
