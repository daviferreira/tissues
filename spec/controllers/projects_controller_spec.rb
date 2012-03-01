require 'spec_helper'

describe ProjectsController do
  render_views
  
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project, :user => user, :name => "Sample Project") }
  
  describe "as a signed-in user" do
    
    before { sign_in user }

    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
      
      it "should list the user's projects" do
        p1 = Factory(:project, :user => user, :name => "Foo bar")
        p2 = Factory(:project, :user => user, :name => "Baz quux")
        get 'index'
        response.body.should have_selector('h1', :text => p1.name)
        response.body.should have_selector('h1', :text => p2.name)
      end
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show', :id => project
        response.should be_success
      end
    end
    
    describe "create project" do
      
      describe "GET 'new'" do
        it "returns http success" do
          get 'new'
          response.should be_success
        end
      end
      
      describe "POST 'create'" do
        it "returns http success" do
          post 'create'
          response.should be_success
        end
      end

      describe "with invalid project data" do
        it "should render new project template" do
          post 'create', :project => user.projects.new(name: "")
          response.should render_template("projects/new")
        end
      end
      
      describe "with valid project data" do
        it "should redirect to projects path" do
          post 'create', :project => {:name => "Test project"}
          response.should redirect_to(projects_path)
        end
      end
      
    end
    
    describe "edit project" do

      describe "GET 'edit'" do
        it "returns http success" do
          get 'edit', :id => project
          response.should be_success
        end
      end
      
      describe "PUT 'update'" do
        
        describe "with invalid project data" do
          it "should render edit project template" do
            post 'update', :id => project, :project => {:name => ""}
            response.should render_template("projects/edit")
          end
        end
        
        describe "with valid project data" do
          it "redirects to project path" do
            put 'update', :id => project, :project => {:name => "Editing project"}
            response.should redirect_to project
          end
          
          it "changes the project name" do
            put 'update', :id => project, :project => {:name => "Editing project"}
            project.reload
            project.name.should == "Editing project"
          end
        end
        
      end
    
    end

    describe "remove project" do
      
      describe "DELETE 'destroy'" do
        
        it "redirects to the project listing path" do
          delete 'destroy', :id => project
          response.should redirect_to projects_path
        end
        
        it "should delete a project" do
          p1 = FactoryGirl.create(:project, :user => user, :name => "Sample Project")
          lambda do
            delete :destroy, :id => p1
          end.should change(Project, :count).by(-1)
        end
        
      end    
        
    end
  
  end
  
  describe "as a non signed-in user" do
  
    describe "GET 'index'" do
      it "redirects to the sign in path" do
        get 'index'
        response.should redirect_to new_user_session_path
      end
    end

    describe "GET 'show'" do
      it "redirects to the sign in path" do
        get 'show'
        response.should redirect_to new_user_session_path
      end
    end

    describe "GET 'new'" do
      it "redirects to the sign in path" do
        get 'new'
        response.should redirect_to new_user_session_path
      end
    end
    
    describe "GET 'edit'" do
      it "redirects to the sign in path" do
        get 'edit', :project => project
        response.should redirect_to new_user_session_path
      end
    end

    describe "POST 'create'" do
      it "redirects to the sign in path" do
        post 'create'
        response.should redirect_to new_user_session_path
      end
    end
    
    describe "PUT 'update'" do
      it "redirects to the sign in path" do
        put 'update'
        response.should redirect_to new_user_session_path
      end
    end
    
    describe "DELETE 'destroy'" do
      it "redirects to the sign in path" do
        delete 'destroy'
        response.should redirect_to new_user_session_path
      end
    end    
  
  end

end
