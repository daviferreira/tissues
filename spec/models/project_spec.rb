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

end
