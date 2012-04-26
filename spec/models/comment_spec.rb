require 'spec_helper'

describe Comment do

  let(:user) { FactoryGirl.create(:user) }
  let(:comment) { FactoryGirl.create(:comment, :user => user) }

  describe "when a comment has children" do
    let(:child) { FactoryGirl.create(:comment, :user => user, :parent => comment) }

    it "should have children" do
      comment.has_children? == true
    end
  end

  describe "when listing user comments" do
    let(:user2) { FactoryGirl.create(:user) }
    let(:comment2) { FactoryGirl.create(:comment, :user => user2) }

    it "should list only the user comments" do
      Comment.find_comments_by_user(user).size == 1
    end
  end

  describe "when listing commentable user" do
    let(:project) { FactoryGirl.create(:project, :user => user) }
    let(:issue) { FactoryGirl.create(:issue, :user => user, :project => project) }
    let(:comment2) { FactoryGirl.create(:comment, :user => user, :commentable => issue) }
    let(:comment3) { FactoryGirl.create(:comment, :user => user) }

    it "should list only the commentable comments" do
      Comment.find_comments_for_commentable("issue", issue.id) == 1
    end

    it "should return the commentable object" do
      Comment.find_commentable("Issue", issue.id) == issue
    end
  end

end