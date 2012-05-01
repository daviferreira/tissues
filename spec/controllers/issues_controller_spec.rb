# coding: utf-8
require 'spec_helper'

describe IssuesController do
  render_views
  
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project, :user => user, :name => "Sample Project") }

  describe "access control" do
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to new_user_session_path
    end
    
    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to new_user_session_path
    end

    it "should deny access to 'details'" do
      get :details, :id => 1
      response.should redirect_to new_user_session_path
    end
  end
  
  describe "POST 'create'" do
    
    before { sign_in user }

    describe "failure" do

      before { @attr = { :content => "" } }

      it "should not create an issue" do
        lambda do
          post :create, :issue => @attr
        end.should_not change(Issue, :count)
      end
      
      it "should redirect to the root path without a project" do
        post :create, :issue => @attr
        response.should redirect_to root_path
      end
      
      it "should redirect to the project page with a project" do
        post :create, :issue => @attr.merge(:project_id => project.id)
        response.should redirect_to project
      end
    end

    describe "success" do
      
      before { @attr = { :content => "Lorem ipsum dolor sit amet", :project_id => project.id } }
      
      it "should create an issue" do
        lambda do
          post :create, :issue => @attr
        end.should change(Issue, :count).by(1)
      end
      
      it "should redirect to the project page" do
        post :create, :issue => @attr
        response.should redirect_to project
      end

      it "should have a flash success message" do
        post :create, :issue => @attr
        flash[:success].should =~ /issue created/i
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do
      
      before(:each) do
        wrong_user = FactoryGirl.create(:user, :email => Factory.next(:email))
        @issue = Factory(:issue, :user => user, :project => project)
        sign_in wrong_user
      end

      it "should deny access" do
        delete :destroy, :id => @issue
        response.should redirect_to(root_path)
      end
    end
    
    describe "for an authorized user" do
      
      before { sign_in user }
      
      it "should destroy the issue" do
        i1 = FactoryGirl.create(:issue, :user => user, :project => project)
        lambda do
          delete :destroy, :id => i1
        end.should change(Issue, :count).by(-1)
      end
      
    end
    
  end

  describe "GET 'details'" do
    let(:issue) { FactoryGirl.create(:issue, :user => user, :project => project) }

    describe "for an authorized user" do
      before { sign_in user }

      it "should redirect to the issue" do
        get :details, :id => issue
        response.should redirect_to(issue)
      end   
    end
  end
  
end