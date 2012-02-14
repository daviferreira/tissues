require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    before do
      FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_selector('title', text: 'All users | Tissues') }

    it "should list each user" do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        page.should have_selector('img', class: 'gravatar', src: "http://gravatar.com/avatar/#{gravatar_id}.png")
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: "#{user.name} | Tissues") }
  end
  
end