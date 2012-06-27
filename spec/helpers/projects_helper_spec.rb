# coding: utf-8
require 'spec_helper'

describe ProjectsHelper do

  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project, :user => user, :name => "Sample Project") }
  let(:issue) { FactoryGirl.create(:issue, :user => user, :project => project) }

  describe "for current user" do

    before :each do
      self.stub!(:current_user) { user }
    end

    describe "formatted issue status and user" do
      it "should return 'submitted by you' when pending" do
        status_with_user(issue).should == "submitted by you"
      end
    end

    describe "show action for an issue" do
      it "is a pending example"
    end

    describe "get user first name" do
      it "is a pending example"
    end

  end

end