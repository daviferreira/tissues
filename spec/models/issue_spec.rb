require 'spec_helper'

describe Issue do

	let(:user) { FactoryGirl.create(:user) }
	let(:project) { FactoryGirl.create(:project, :user => user) }

	before { @issue = user.issues.build(content: "I'm an issue", project_id: project.id) }

	subject { @issue }

	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should respond_to(:project_id) }
	it { should respond_to(:status) }
	it { should respond_to(:who_is_solving) }
	it { should respond_to(:who_is_validating) }
	its(:user) { should == user }
  its(:project) { should == project }

	it { should be_valid }

	describe "when user id is not present" do
		before { @issue.user_id = nil }
		it { should_not be_valid }
	end

	describe "when project id is not present" do
		before { @issue.project_id = nil }
		it { should_not be_valid }
	end

	describe "when content is not present" do
		before { @issue.content = nil }
		it { should_not be_valid }
	end

end