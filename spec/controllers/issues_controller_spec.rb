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

    it "should deny access to 'solve'" do
      get :solve, :id => 1
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
    before { sign_in user }

    it "should redirect to the issue" do
      get :details, :id => issue
      response.should redirect_to(issue)
    end

  end

  describe "edit and issue" do
    let(:issue) { FactoryGirl.create(:issue, :user => user, :project => project) }
    before { sign_in user }

    describe "GET 'edit'" do
      it "returns http success" do
        get :edit, :id => issue
        response.should redirect_to(issue.project)
      end

      it "redirects to the home page user doesn't own the issue" do
        user2 = FactoryGirl.create(:user, :email => "another@example.com")
        issue2 = FactoryGirl.create(:issue, :user => user2, :content => "Baz quux", :project => project)
        get :edit, :id => issue2
        response.should redirect_to root_path
      end
    end

  end

  describe "solve an issue" do
    let(:issue) { FactoryGirl.create(:issue, :user => user, :project => project) }
    before { sign_in user }

    describe "GET 'solve'" do
      it "should be possible for users to solve an issue" do
        get :solve, :id => issue
        issue.reload
        issue.who_is_solving.should == user
        issue.status.should == "in progress"
      end

      it "should only be possible to solve pending issues" do
        ["waiting for validation", "in progress", "validating", "done"].each do |status|
          issue.status = status
          issue.save
          get :solve, :id => issue
          issue.reload
          issue.who_is_solving.should == nil
          issue.status.should == status
        end
      end
    end

    describe "GET 'done_solving'" do
      before(:each) do
        get :solve, :id => issue
        issue.reload
      end

      it "shouldn't do anything with the wrong user" do
        sign_out user
        user2 = FactoryGirl.create(:user, :email => "another@example.com")
        sign_in user2
        get :done_solving, :id => issue
        issue.reload
        issue.status.should == "in progress"
      end

      it "shouldn't do anything with the wrong status" do
        ["waiting for validation", "pending", "validating", "done"].each do |status|
          issue.status = status
          issue.save
          issue.reload
          get :done_solving, :id => issue
          issue.who_is_solving.should == user
          issue.status.should == status
        end
      end

      it "should be possible for an user to mark an issue as solved" do
        get :done_solving, :id => issue
        issue.reload
        issue.status.should == "waiting for validation"
      end
    end

    describe "GET 'abandon_solving'" do
      it "shouldn't do anything with the wrong status" do
        ["waiting for validation", "pending", "validating", "done"].each do |status|
          issue.status = status
          issue.save
          get :abandon_solving, :id => issue
          issue.reload
          issue.who_is_solving.should == nil
          issue.status.should == status
        end
      end

      it "shouldn't do anything with the wrong user" do
        user2 = FactoryGirl.create(:user, :email => "another@example.com")
        get :solve, :id => issue
        issue.reload
        sign_out user
        sign_in user2
        get :done_solving, :id => issue
        issue.reload
        issue.who_is_solving.should == user
        issue.status.should == "in progress"
      end

      it "should be possible for an user to give up on solving an issue" do
        get :solve, :id => issue
        issue.reload
        issue.who_is_solving.should == user
        issue.status.should == "in progress"
        get :abandon_solving, :id => issue
        issue.reload
        issue.who_is_solving.should == nil
        issue.status.should == "pending"
      end
    end

    describe "validate an issue" do
      let(:issue) { FactoryGirl.create(:issue, :user => user, :project => project,
                                       :status => "waiting for validation",
                                       :who_is_solving => user) }
      before { sign_in user }

      describe "GET 'validate'" do
        it "shouldn't do anything when the user tries to validate his own issue" do
          get :validate, :id => issue
          issue.reload
          issue.status.should == "waiting for validation"
          issue.who_is_solving.should == user
          issue.who_is_validating.should == nil
        end

        it "should be possible for users to validate an issue" do
          sign_out user
          user2 = FactoryGirl.create(:user, :email => "another@example.com")
          sign_in user2
          get :validate, :id => issue
          issue.reload
          issue.status.should == "validating"
          issue.who_is_validating.should == user2
        end

        it "should only be possible to solve issues waiting for validation" do
          ["pending", "in progress", "validating", "done"].each do |status|
            issue.status = status
            issue.save
            get :validate, :id => issue
            issue.reload
            issue.who_is_validating.should == nil
            issue.status.should == status
          end
        end
      end

      describe "GET 'abandon_validation'" do
        let(:user2) { FactoryGirl.create(:user, :email => "another@example.com") }

        before(:each) do
          sign_in user2
          get :validate, :id => issue
          issue.reload
        end

        it "shouldn't do anything with the wrong status" do
          ["waiting for validation", "pending", "in progress", "done"].each do |status|
            issue.status = status
            issue.save
            get :abandon_validation, :id => issue
            issue.reload
            issue.who_is_validating.should == user2
            issue.status.should == status
          end
        end

        it "shouldn't do anything with the wrong user" do
          sign_out user2
          sign_in user
          get :abandon_validation, :id => issue
          issue.reload
          issue.who_is_validating.should == user2
          issue.status.should == "validating"
        end

        it "should be possible for an user to give up on solving an issue" do
          get :abandon_validation, :id => issue
          issue.reload
          issue.who_is_validating.should == nil
          issue.status.should == "waiting for validation"
        end
      end

      describe "GET 'done_validating'" do
        let(:user2) { FactoryGirl.create(:user, :email => "another@example.com") }

        before(:each) do
          sign_in user2
          get :validate, :id => issue
          issue.reload
        end

        it "shouldn't do anything with the wrong status" do
          ["waiting for validation", "pending", "in progress", "done"].each do |status|
            issue.status = status
            issue.save
            get :done_validating, :id => issue, :status => status
            issue.reload
            issue.who_is_validating.should == user2
            issue.status.should == status
          end
        end

        it "shouldn't do anything with the wrong user" do
          sign_out user2
          sign_in user
          get :done_validating, :id => issue, :status => "done"
          issue.reload
          issue.who_is_validating.should == user2
          issue.status.should == "validating"
        end

        it "should be possible for an user to mark an issue as validated" do
          get :done_validating, :id => issue, :status => "done"
          issue.reload
          issue.status.should == "done"
        end

        it "should be possible for an user to mark an issue as not approved" do
          get :done_validating, :id => issue, :status => "not approved"
          issue.reload
          issue.status.should == "not approved"
        end
      end

    end

  end

end