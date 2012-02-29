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
  end
  
  def create
    @project = current_user.projects.build(params[:project])
    if @project.save
      flash[:success] = "Project created!"
      redirect_to projects_path
    else
      render 'projects/new'
    end
  end
  
  def update
  end
  
  def destroy
  end
end
