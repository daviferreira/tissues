require 'spec_helper'

describe "Session pages" do
  
  subject { page }
  
  describe "sign up" do
    before { visit new_user_registration_path }
    it { should have_selector('title', text: 'Create an Account | Tissues') }
    it { should have_selector('ul.breadcrumb > li > a', :text => "Home", :href => root_path) }
    it { should have_selector('ul.breadcrumb > li.active > a', :text => "Create an account", :href => new_user_registration_path) }
  end
  
  describe "sign in" do
    before { visit new_user_session_path }
    it { should have_selector('title', text: 'Sign in | Tissues') }
    it { should have_selector('ul.breadcrumb > li > a', :text => "Home", :href => root_path) }
    it { should have_selector('ul.breadcrumb > li.active > a', :text => "Sign in", :href => new_user_session_path) }
  end
  
  describe "forgot your password" do
    before { visit new_user_password_path }
    it { should have_selector('title', text: 'Forgot your password? | Tissues') }
    it { should have_selector('ul.breadcrumb > li > a', :text => "Home", :href => root_path) }
    it { should have_selector('ul.breadcrumb > li.active > a', :text => "Forgot your password?", :href => new_user_password_path) }
  end
  
end