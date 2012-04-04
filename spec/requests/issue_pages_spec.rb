require 'spec_helper'

describe "IssuePages" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project, user: user) }

  describe "as an authenticated user" do

    before do
      visit new_user_session_path
      valid_signin user 
    end

    describe "issues listing" do
      let!(:i1) { FactoryGirl.create(:issue, user: user, project: project, content: "Issue #1") }
      let!(:i2) { FactoryGirl.create(:issue, user: user, project: project, content: "Issue #2") }

      before { visit issues_path }

      it { should have_selector('title', :text => "#{I18n.t("issues.title")} | Tissues") }
      it { should have_selector('ul.breadcrumb > li > a', :text => I18n.t("home.title"), :href => root_path) }
      it { should have_selector('ul.breadcrumb > li.active > a', :text => I18n.t("issues.title"), :href => issues_path) }
      
      it { should have_selector('article.issue > p', :text => i1.content) }
      it { should have_selector('article.issue > p > span > a', :text => i1.project.name) }
      it { should have_selector('article.issue > p.author', :text => "#{I18n.t("issues.author")} #{i1.user.name}") }

      it { should have_selector('article.issue > p', :text => i2.content) }
      it { should have_selector('article.issue > p > span > a', :text => i2.project.name) }
      it { should have_selector('article.issue > p.author', :text => "#{I18n.t("issues.author")} #{i1.user.name}") }

    end

  end

end
