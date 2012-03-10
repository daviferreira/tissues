require 'spec_helper'

describe "StaticPages" do

  subject { page }
  
  describe "Home page" do
    
    before { visit '/static_pages/home' }
    
    it { should have_content('Tissues') }
    it { should have_selector('title', :text => "#{I18n.t(:home)} | Tissues") }
    it { should_not have_selector('a', :href => new_project_path, :text => I18n.t(:create_project)) }

    describe "As a signed-in user" do
      let(:user) { FactoryGirl.create(:user) }
      
      before do
        visit new_user_session_path
        valid_signin user 
      end
      
      it { should have_selector('a', :href => new_project_path, :text => I18n.t(:create_project)) }
      it { should have_selector('img.gravatar') }
    end
    
  end
  
  describe "Help page" do

    before { visit '/static_pages/help' }

    it { should have_content('Help') }
    it { should have_selector('title', :text => "#{I18n.t(:help)} | Tissues") }
    it { should have_selector('ul.breadcrumb > li > a', :text => I18n.t(:home), :href => root_path) }
    it { should have_selector('ul.breadcrumb > li.active > a', :text => I18n.t(:help), :href => static_pages_help_path) }
    
  end
  
  describe "About page" do

    before { visit '/static_pages/about' }

    it { should have_content('About') }
    it { should have_selector('title', :text => "#{I18n.t(:about)} | Tissues") }
    it { should have_selector('ul.breadcrumb > li > a', :text => I18n.t(:home), :href => root_path) }
    it { should have_selector('ul.breadcrumb > li.active > a', :text => I18n.t(:about), :href => static_pages_about_path) }
  
  end
  
end