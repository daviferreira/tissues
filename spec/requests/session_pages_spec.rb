require 'spec_helper'

describe "Session pages" do
  
  subject { page }
  
  describe "sign up" do
    before { visit new_user_registration_path }
    it { should have_selector('title', text:"#{I18n.t(:create_account)} | Tissues") }
  end
  
  describe "sign in" do
    before { visit new_user_session_path }
    it { should have_selector('title', text: "#{I18n.t(:sign_in)} | Tissues") }
  end
  
  describe "forgot your password" do
    before { visit new_user_password_path }
    it { should have_selector('title', text: "#{I18n.t(:forgot_your_password)} | Tissues") }
  end
  
end