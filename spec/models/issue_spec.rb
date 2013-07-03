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

	describe "with blank content" do
    before { @issue.content = " " }
    it { should_not be_valid }
  end

  describe "when solving" do

  	it "should be possible to solve when pending" do
  		@issue.status = "pending"
  		@issue.can_be_solved.should be_true
  	end

  	it "should be possible to solve when not approved" do
  		@issue.status = "not approved"
  		@issue.can_be_solved.should be_true
  	end

  	it "should not be possible to solve with any another status" do
  		["done", "in progress", "waiting for validation", "validating"].each do |status|
  			@issue.status = status
  			@issue.can_be_solved.should be_false
  		end
  	end

  end

  describe "when finishing" do

  	it "should be possible to finish when solving" do
  		@issue.status = "in progress"
  		@issue.who_is_solving = user
  		@issue.can_be_finished_by(user, "solving").should be_true
  	end

  	it "should be possible to finish when validating" do
  		@issue.status = "validating"
  		@issue.who_is_validating = user
  		@issue.can_be_finished_by(user, "validating").should be_true
  	end

  	it "should not be possible to finish solving with different users" do
  		user2 = FactoryGirl.create(:user, :email => "teste@issues.com")
  		@issue.who_is_solving = user2
  		@issue.can_be_finished_by(user, "solving").should be_false
  	end

  	it "should not be possible to finish validating with different users" do
  		user2 = FactoryGirl.create(:user, :email => "teste@issues.com")
  		@issue.who_is_validating = user2
  		@issue.can_be_finished_by(user, "validating").should be_false
  	end

  	it "should not be possible to finish with any other status" do
  		@issue.who_is_solving = @issue.who_is_validating = user
  		["done", "waiting for validation", "pending", "not_approved"].each do |status|
  			@issue.status = status
  			@issue.can_be_finished_by(user, "solving").should be_false
  			@issue.can_be_finished_by(user, "validating").should be_false
  		end
  	end

  	it "should not be possible to finish with an invalid type" do
  		@issue.status = "invalid status"
  		@issue.who_is_solving = user
  		@issue.can_be_finished_by(user, "solving").should be_false
  	end

  end

  describe "when validating" do

  	it "should be possible to validate when waiting for validation" do
  		@issue.status = "waiting for validation"
  		@issue.can_be_validated_by(user).should be_true
  	end

  	it "should not be possible to validate when user is solving" do
  		@issue.status = "waiting for validation"
  		@issue.who_is_solving = user
  		@issue.can_be_validated_by(user).should be_false
  	end

  	it "should not be possible to validate with any another status" do
  		@issue.who_is_solving = nil
  		["done", "in progress", "pending", "validating", "not_approved"].each do |status|
  			@issue.status = status
  			@issue.can_be_validated_by(user).should be_false
  		end
  	end

  end

end