require 'spec_helper'

describe Project do
  
  before { @project = Project.new(name: "Example Project", status: "active") }

  subject { @project }

  it { should respond_to(:name) }
  it { should respond_to(:status) }
  
  it { should be_valid }

  describe "when name is not present" do
    before { @project.name = " " }
    it { should_not be_valid }
  end
  
end
