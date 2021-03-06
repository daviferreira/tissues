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

    it { should have_selector('title', text: "#{I18n.t("users.all")} | Tissues") }

    it "should list each user" do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
        page.should have_selector('img', class: 'avatar')
      end
    end

  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:p1) { FactoryGirl.create(:project, user: user, name: "Foo") }
    let!(:p2) { FactoryGirl.create(:project, user: FactoryGirl.create(:user, email: "newuser@example.com"), name: "Bar") }
    let!(:i1) { FactoryGirl.create(:issue, project: p1, user: user) }
    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: "#{user.name} | Tissues") }
    it { should have_selector('p', text: "#{user.projects.count.to_s} Project") }
    it { should have_selector('p', text: "#{user.issues.count.to_s} Issue") }

    describe "my projects" do
      it { should have_content(p1.name) }
      it { should_not have_content(p2.name) }
      it { should have_content(user.projects.count) }
    end

    describe "pluralize" do
      it "should not pluralize 1 issue and 1 project" do
        find('#user-page .well p').text.should == '1 Project, 1 Issue'
      end

      it "should pluralize 2 projects" do
        FactoryGirl.create(:project, user: user, name: "Foo 2")
        visit user_path(user)
        find('#user-page .well p').text.should == '2 Projects, 1 Issue'
      end

      it "should pluralize 2 issues" do
        FactoryGirl.create(:issue, project: p1, user: user)
        visit user_path(user)
        find('#user-page .well p').text.should == '1 Project, 2 Issues'
      end
    end

  end

  describe "Devise" do
    before { visit new_user_registration_path }

    describe "error messages" do
      let(:error) { '3 errors prohibited this user from being saved' }
      before { click_button "Sign up" }
      it { should have_content(error) }
    end
  end

  describe "Avatar" do

    describe "new user" do
      before { visit new_user_registration_path }

      it { should have_selector('input', type: "file", id: "user_avatar") }
    end

    describe "existing user" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        visit new_user_session_path
        valid_signin user
        visit edit_user_registration_path
      end

      it { should have_selector('input', type: "file", id: "user_avatar") }
    end
  end

end
