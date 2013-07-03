require 'spec_helper'

describe User do

  before { @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  # i'm not validating Devise, just the new fields
  it { should respond_to(:name) }
  it { should respond_to(:projects) }
  it { should respond_to(:issues) }

  it { should have_attached_file(:avatar) }
  it { should validate_attachment_content_type(:avatar).
                allowing('image/png', 'image/gif', 'image/jpeg').
                rejecting('text/plain', 'text/xml') }
  it { should validate_attachment_size(:avatar).
                less_than(2.megabytes) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "projects associations" do
    before { @user.save }
    let!(:older_project) do
      FactoryGirl.create(:project, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_project) do
      FactoryGirl.create(:project, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right projects in the right order" do
      @user.projects.should == [newer_project, older_project]
    end

    it "should destroy associated projects" do
      projects = @user.projects
      @user.destroy
      projects.each do |project|
        project.find_by_id(project.id).should be_nil
      end
    end
  end

  describe "listing users" do
    before { @user.save }
    let!(:user_a) do
      FactoryGirl.create(:user, name: "A user", email: "auser@example.com")
    end
    let!(:user_x) do
      FactoryGirl.create(:user, name: "X user", email: "xuser@example.com")
    end
    it "should have the right users in the right order" do
      User.all.should == [user_a, @user, user_x]
    end
  end

  describe "issues associations" do
    before { @user.save }
    let!(:project) {FactoryGirl.create(:project, user: @user) }
    let!(:older_issue) do
      FactoryGirl.create(:issue, user: @user, project: project, created_at: 1.day.ago)
    end
    let!(:recent_issue) do
      FactoryGirl.create(:issue, user: @user, project: project, created_at: 1.hour.ago)
    end

    it "should have the right issues in the right order" do
      @user.issues.should == [older_issue, recent_issue]
    end

    it "should destroy associated issues" do
      issues = @user.issues
      @user.destroy
      issues.each do |issue|
        issue.find_by_id(issue.id).should be_nil
      end
    end
  end

end
