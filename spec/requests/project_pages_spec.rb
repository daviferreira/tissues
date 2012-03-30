require 'spec_helper'

describe "project pages" do

  subject { page }
  let(:user) { FactoryGirl.create(:user) }

  describe "as an authenticated user" do
    
    before do
      visit new_user_session_path
      valid_signin user 
    end
    
    describe "project listing" do 
      let!(:p1) { FactoryGirl.create(:project, user: user, name: "Foo") }
      let!(:p2) { FactoryGirl.create(:project, user: user, name: "Bar") }

      before { visit projects_path }
      
      it { should have_selector('title', :text => "#{I18n.t(:projects)} | Tissues") }
      it { should have_selector('ul.breadcrumb > li > a', :text => I18n.t(:home), :href => root_path) }
      it { should have_selector('ul.breadcrumb > li.active > a', :text => I18n.t(:projects), :href => projects_path) }
      
      it { should have_selector('article > header > h1', :text => p1.name) }
      it { should have_selector('article > header > h1', :text => p2.name) }
      
      it { should have_selector('div.project-actions > a', :text => I18n.t(:edit_project), :href => edit_project_path(p1)) }
      it { should have_selector('div.project-actions > a', :text => I18n.t(:edit_project), :href => edit_project_path(p2)) }
      it { should have_selector('div.project-actions > a', :text => I18n.t(:delete_project), :href => p1, :method => :delete) }
      it { should have_selector('div.project-actions > a', :text => I18n.t(:delete_project), :href => p2, :method => :delete) }

      it { should have_selector('span.issues', :text => "#{p1.issues.count}") }
      it { should have_selector('span.issues', :text => "#{p2.issues.count}") }

    end
    
    describe "project listing from different users" do
      let!(:p3) { FactoryGirl.create(:project, user: user2, name: "Foo User 2") }
      let!(:p4) { FactoryGirl.create(:project, user: user2, name: "Bar User 2") }
    
      let(:user2) { FactoryGirl.create(:user, :email => "second@example.com") }
      
      before { visit projects_path }
      
      it { should have_selector('article > header > h1', :text => p3.name) }
      it { should have_selector('article > header > h1', :text => p4.name) }
      
      it { has_selector?('div.project-actions > a', :text => I18n.t(:edit_project), :href => edit_project_path(p3)).should be_false }
      it { has_selector?('div.project-actions > a', :text => I18n.t(:edit_project), :href => edit_project_path(p4)).should be_false }
      it { has_selector?('div.project-actions > a', :text => I18n.t(:delete_project), :href => p3, :method => :delete).should be_false }
      it { has_selector?('div.project-actions', :text => I18n.t(:delete_project), :href => p4, :method => :delete).should be_false }
    end
    
    describe "show a project" do
      let!(:p1) { FactoryGirl.create(:project, user: user, name: "Foo") }
      let!(:i1) { FactoryGirl.create(:issue, user: user, project: p1, content: "Issue #1") }
      let!(:i2) { FactoryGirl.create(:issue, user: user, project: p1, content: "Issue #2") }
      
      before { visit project_path(p1) }
      
      it { should have_selector('title', :text =>"#{p1.name} | Tissues") }
      it { should have_selector('h1', :text => p1.name) }
      it { should have_selector('p.lead > a', :href => p1.url) }
      it { should have_selector('ul.breadcrumb > li > a', :text => I18n.t(:home), :href => root_path) }
      it { should have_selector('ul.breadcrumb > li > a', :text => I18n.t(:projects), :href => projects_path) }
      it { should have_selector('ul.breadcrumb > li.active > a', :text => p1.name, :href => project_path(p1)) }
      
      it { should have_selector('a.archive-project', :text => I18n.t(:archive_project), :href => archive_project_path(p1)) }

      describe "issues" do      
        it { should have_selector('li', :text => i1.content) }
        it { should have_selector('li', :text => i2.content) }
        it { should have_selector('a#create-issue', :text => I18n.t(:create_issue)) }
        
        describe "with invalid information" do

          it "should not create a issue" do
            expect { click_button I18n.t(:submit_issue) }.should_not change(Issue, :count)
          end

          describe "error messages" do
            before { click_button I18n.t(:submit_issue) }
            it { should have_content('error') } 
          end
        end

        describe "with valid information" do

          before { fill_in 'issue_content', with: "Lorem ipsum" }
          it "should create a issue" do
            expect { click_button I18n.t(:submit_issue) }.should change(Issue, :count).by(1)
          end
        end
        
      end
    end

    describe "project creation" do
      before { visit new_project_path }

      it { should have_selector('title', :text => "New Project | Tissues") }
      it { should have_selector('ul.breadcrumb > li > a', :text => I18n.t(:home), :href => root_path) }
      it { should have_selector('ul.breadcrumb > li > a', :text => I18n.t(:projects), :href => projects_path) }
      it { should have_selector('ul.breadcrumb > li.active > a', :text => I18n.t(:create_project), :href => new_project_path) }

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

      it { should have_selector('title', :text => "#{I18n.t(:edit_project)} #{project.name} | Tissues") }

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

    describe "archive project" do
      let!(:p1) { FactoryGirl.create(:project, user: user, name: "Foo") }

      before { visit project_path(p1) }
      
      it "should archive a project" do
        click_link I18n.t(:archive_project)
        p1.reload
        p1.status.should == "archived"
      end
      
      describe "project archived message" do
        before { click_link I18n.t(:archive_project) }
        it { should have_content("Project archived.") }
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