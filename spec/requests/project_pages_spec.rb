require 'spec_helper'

describe "project pages" do

  subject { page }

  describe "as an authenticated user" do
    
    let(:user) { FactoryGirl.create(:user) }
    before { 
      visit new_user_session_path
      valid_signin user 
    }

    describe "project creation" do
      before { visit new_project_path }

      describe "with invalid information" do

        it "should not create a project" do
          expect { click_button "Submit" }.should_not change(Project, :count)
        end

        describe "error messages" do
          let(:error) { '1 error prohibited this project from being saved' }
          before { click_button "Submit" }
          it { should have_content(error) } 
        end
      end

      describe "with valid information" do

        before { fill_in 'project_name', with: "Lorem ipsum" }
        it "should create a project" do
          expect { click_button "Submit" }.should change(Project, :count).by(1)
        end
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