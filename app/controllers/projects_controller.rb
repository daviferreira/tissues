class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @projects = current_user.projects
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = current_user.projects.build
  end
  
  def edit
    @project = Project.find(params[:id])
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
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      redirect_to @project, :flash => { :success => "Project updated." }
    else
      render 'edit'
    end
  end
  
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_path, :flash => { :success => "Project destroyed." }
  end
end
