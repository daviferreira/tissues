require 'spec_helper'

describe "project pages" do

  subject { page }
  let(:user) { FactoryGirl.create(:user) }

  describe "as an authenticated user" do
    
    before { 
      visit new_user_session_path
      valid_signin user 
    }
    
    describe "project listing" do
      let!(:p1) { FactoryGirl.create(:project, user: user, name: "Foo") }
      let!(:p2) { FactoryGirl.create(:project, user: user, name: "Bar") }

      before { visit projects_path }
      
      it { should have_selector('title', :text => "My Projects | Tissues") }
      it { should have_selector('h1', :text => p1.name) }
      it { should have_selector('h1', :text => p2.name) }
      it { should have_selector('a', :text => "Edit project", :href => edit_project_path(p1)) }
      it { should have_selector('a', :text => "Edit project", :href => edit_project_path(p2)) }
      it { should have_selector('a', :text => "Delete project", :href => p1, :method => :delete) }
      it { should have_selector('a', :text => "Delete project", :href => p2, :method => :delete) }
      
      it { should have_selector('ul.breadcrumb > li > a', :text => "Home", :href => root_path) }
      it { should have_selector('ul.breadcrumb > li.active > a', :text => "Projects", :href => projects_path) }
    end
    
    describe "show a project" do
      let!(:p1) { FactoryGirl.create(:project, user: user, name: "Foo") }
      
      before { visit project_path(p1) }
      
      it { should have_selector('title', :text =>"#{p1.name} | Tissues") }
      it { should have_selector('h1', :text => p1.name) }
    end

    describe "project creation" do
      before { visit new_project_path }

      it { should have_selector('title', :text => "New Project | Tissues") }
      it { should have_selector('ul.breadcrumb > li > a', :text => "Home", :href => root_path) }
      it { should have_selector('ul.breadcrumb > li > a', :text => "Projects", :href => projects_path) }
      it { should have_selector('ul.breadcrumb > li.active > a', :text => "Create project", :href => new_project_path) }

      describe "with invalid information" do

        it "should not create a project" do
          expect { click_button "Create project" }.should_not change(Project, :count)
        end

        describe "error messages" do
          let(:error) { '1 error prohibited this project from being saved' }
          before { click_button "Create project" }
          it { should have_content(error) } 
        end
      end

      describe "with valid information" do

        before { fill_in 'project_name', with: "Lorem ipsum" }
        
        it "should create a project" do
          expect { click_button "Create project" }.should change(Project, :count).by(1)
        end
                
      end
    end

    describe "project edit" do
      let(:project) { FactoryGirl.create(:project, :user => user, :name => "Test Project") }
      before { visit edit_project_path(project) }

      it { should have_selector('title', :text => "Edit Project #{project.name} | Tissues") }

      describe "with invalid information" do

        before { fill_in 'project_name', with: "" }

        describe "error messages" do
          let(:error) { '1 error prohibited this project from being saved' }
          before { click_button "Create project" }
          it { should have_content(error) } 
        end
      end

      describe "with valid information" do

        before { fill_in 'project_name', with: "Lorem ipsum" }
        before { click_button "Create project" }
        
        it "should edit a project" do
          project.reload
          project.name.should == "Lorem ipsum"
        end
        
        it { should have_content("Project updated.") }
                
      end
    end
    
    describe "delete project" do
      let!(:p1) { FactoryGirl.create(:project, user: user, name: "Foo") }

      before { visit projects_path }
      
      it "should destroy a project" do
        expect { click_link "Delete project" }.should change(Project, :count).by(-1)
      end
      
      describe "project destroyed message" do
        before { click_link "Delete project" }
        it { should have_content("Project destroyed.") }
      end
    end
    
  end
  
  describe "as a non-authenticated user" do
    
    let(:user) { FactoryGirl.create(:user) }
    
    describe "in the projects controller" do

      describe "submitting to the create action" do
        before { post projects_path }
        specify { response.should redirect_to(new_user_session_path) }
      end
      
      describe "submitting to the edit action" do
        before do
          project = FactoryGirl.create(:project)
          put project_path(project)
        end
        specify { response.should redirect_to(new_user_session_path) }
      end

      describe "submitting to the destroy action" do
        before do
          project = FactoryGirl.create(:project)
          delete project_path(project)
        end
        specify { response.should redirect_to(new_user_session_path) }
      end
      

    end

  end
  
end