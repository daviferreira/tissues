require 'spec_helper'

describe "Session pages" do
  
  subject { page }
  
  describe "sign up" do
    before { visit new_user_registration_path }
    it { should have_selector('title', text:"#{I18n.t(:create_account)} | Tissues") }
    it { should have_selector('ul.breadcrumb > li > a', :text => I18n.t("home.title"), :href => root_path) }
    it { should have_selector('ul.breadcrumb > li.active > a', :text => I18n.t(:create_account), :href => new_user_registration_path) }
  end
  
  describe "sign in" do
    before { visit new_user_session_path }
    it { should have_selector('title', text: "#{I18n.t(:sign_in)} | Tissues") }
    it { should have_selector('ul.breadcrumb > li > a', :text => I18n.t("home.title"), :href => root_path) }
    it { should have_selector('ul.breadcrumb > li.active > a', :text => I18n.t(:sign_in), :href => new_user_session_path) }
  end
  
  describe "forgot your password" do
    before { visit new_user_password_path }
    it { should have_selector('title', text: "#{I18n.t(:forgot_your_password)} | Tissues") }
    it { should have_selector('ul.breadcrumb > li > a', :text => I18n.t("home.title"), :href => root_path) }
    it { should have_selector('ul.breadcrumb > li.active > a', :text => I18n.t(:forgot_your_password), :href => new_user_password_path) }
  end
  
end