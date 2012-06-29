# coding: utf-8
require 'spec_helper'

describe ProjectsHelper do

  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project, :user => user, :name => "Sample Project") }
  let(:issue) { FactoryGirl.create(:issue, :user => user, :project => project, :who_is_validating => user, :who_is_solving => user) }

  describe "for current user" do

    before :each do
      self.stub!(:current_user) { user }
    end

    describe "formatted issue status and user" do
      it "should return 'submitted by you' when 'pending'" do
        status_with_user(issue).should == "submitted by you"
      end

      it "should return 'you are working on it' when 'in progress'" do
        issue.status = "in progress"
        status_with_user(issue).should == "you are working on it"
      end

      it "should return 'you are validating it' when 'validating'" do
        issue.status = "validating"
        status_with_user(issue).should == "you are validating it"
      end

      it "should return 'you said it's still not valid' when 'not approved'" do
        issue.status = "not approved"
        status_with_user(issue).should == "you said it's still not valid"
      end

      it "should return 'you solved it' when 'done'" do
        issue.status = "done"
        status_with_user(issue).should == "you solved it"
      end

      it "should return 'you solved it, waiting for validation' when 'waiting for validation'" do
        issue.status = "waiting for validation"
        status_with_user(issue).should == "you solved it, waiting for validation"
      end
    end

    describe "show action for an issue" do
      it "should render solve button when the issue is pending" do
        show_action_for(issue).should == render("issues/button_solve", :issue => issue)
      end

      it "shouldn't render anything when the issue is waiting for validation" do
        issue.status = "waiting for validation"
        show_action_for(issue).should == nil
      end

      it "should render the done button when the issue is in progress" do
        issue.status = "in progress"
        show_action_for(issue).should == render("issues/button_done", :issue => issue)
      end

      it "should render the validation buttons when the issue is being validated" do
        issue.status = "validating"
        show_action_for(issue).should == render("issues/buttons_validation", :issue => issue)
      end
    end

    describe "get user first name" do
      it "is a pending example"
    end

  end

end