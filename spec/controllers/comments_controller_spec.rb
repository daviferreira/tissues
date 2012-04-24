# coding: utf-8
require 'spec_helper'

describe CommentsController do
  render_views

  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project, :user => user, :name => "Sample Project") }
  let(:issue) {FactoryGirl.create(:issue, :project => project, :user => user, :content => "Sample Issue")}

  describe "access control" do
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to new_user_session_path
    end
  end

  describe "POST 'create'" do
    
    before { sign_in user }

    describe "failure" do

      before { @attr = { :body => "", :issue_id => issue.id } }

      it "should not create a comment" do
        lambda do
          post :create, :comment => @attr
        end.should_not change(Comment, :count)
      end
            
      it "should redirect to the project page" do
        post :create, :comment => @attr
        response.should redirect_to project
      end
    end

    describe "success" do
      
      before { @attr = { :body => "Lorem ipsum dolor sit amet", :issue_id => issue.id } }
      
      it "should create a comment" do
        lambda do
          post :create, :comment => @attr
        end.should change(Comment, :count).by(1)
      end
      
      it "should redirect to the issue page" do
        post :create, :comment => @attr
        response.should redirect_to project
      end

      it "should have a flash success message" do
        post :create, :comment => @attr
        flash[:success].should == I18n.t("comments.comment_created")
      end
    end
  end

end