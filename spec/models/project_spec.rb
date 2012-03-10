require 'spec_helper'

describe Project do
  
  let(:user) { FactoryGirl.create(:user) }
  before do
    @project = user.projects.new(name: "Example Project", status: "active")
  end

  subject { @project }

  it { should respond_to(:name) }
  it { should respond_to(:status) }
  it { should respond_to(:user) }
  it { should respond_to(:issues) }
  its(:user) { should == user }
    
  it { should be_valid }

  describe "when name is not present" do
    before { @project.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @project.name = "a" * 141 }
    it { should_not be_valid }
  end
  
  describe "when user_id is not present" do
    before { @project.user_id = nil }
    it { should_not be_valid }
  end

  describe "issues associations" do
    before do
      user.save
      @project.save
    end

    let!(:older_issue) do 
      FactoryGirl.create(:issue, user: user, project: @project, updated_at: 1.day.ago)
    end
    let!(:recent_updated_issue) do
      FactoryGirl.create(:issue, user: user, project: @project, updated_at: 1.hour.ago)
    end

    it "should have the right issues in the right order" do
      @project.issues.should == [recent_updated_issue, older_issue]
    end
    
    it "should destroy associated issues" do
      issues = @project.issues
      @project.destroy
      issues.each do |issue|
        issue.find_by_id(issue.id).should be_nil
      end
    end
  end

end
