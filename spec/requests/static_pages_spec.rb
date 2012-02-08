require 'spec_helper'

describe "StaticPages" do

  subject { page }
  
  describe "Home page" do
    
    before { visit '/static_pages/home' }
    
    it { should have_content('Tissues') }
    it { should have_selector('title', :text => "Home | Tissues") }
    
  end
  
  describe "Help page" do

    before { visit '/static_pages/help' }

    it { should have_content('Help') }
    it { should have_selector('title', :text => "Help | Tissues") }
    
  end
  
  describe "About page" do

    before { visit '/static_pages/about' }

    it { should have_content('About') }
    it { should have_selector('title', :text => "About | Tissues") }
    
  end
  
end
