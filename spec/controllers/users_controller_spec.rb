require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index'" do

    before(:each) do
      sign_in(Factory(:user))
      second = Factory(:user, :name => "Bob", :email => "another@example.com")
      third  = Factory(:user, :name => "Ben", :email => "another@example.net")
      
      30.times do
        Factory(:user, :name => Factory.next(:name),
                       :email => Factory.next(:email))
      end
    end
    
    it "should be successful" do
      get :index
      response.should be_success
    end
    
    it "should have the right title" do
      get :index
      response.body.should have_selector('title', :content => "All users | Tissues")
    end
    
    it "should have an element for each user" do
      get :index
      User.paginate(:page => 1).each do |user|
        response.body.should have_selector('li', :content => user.name)
      end
    end
    
    it "should paginate users" do
      get :index
      response.body.should have_selector('div.pagination')
      response.body.should have_selector('span.disabled', :content => "Previous")
      response.body.should have_selector('a', :href => "/users?page=2",
                                         :content => "2")
      response.body.should have_selector('a', :href => "/users?page=2",
                                         :content => "Next")
    end


  end

  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end
  
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.body.should have_selector('title', :content => @user.name)
    end
    
    it "should have the user's name" do
      get :show, :id => @user
      response.body.should have_selector('h1', :content => @user.name)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      response.body.should have_selector('img', :class => "gravatar")
    end
    
    it "should show the user's projects" do
      p1 = Factory(:project, :user => @user, :name => "Foo bar")
      p2 = Factory(:project, :user => @user, :name => "Baz quux")
      get :show, :id => @user
      response.body.should have_selector('h1', :content => p1.name)
      response.body.should have_selector('h1', :content => p2.name)
    end
    
    it "should paginate projects" do
      35.times { Factory(:project, :user => @user, :name => "foo") }
      get :show, :id => @user
      response.body.should have_selector('div.pagination')
    end
    
    it "should display the project count" do
      10.times { Factory(:project, :user => @user, :name => "foo") }
      get :show, :id => @user
      response.body.should have_selector('strong',
                                    :content => @user.projects.count.to_s)
    end
    
  end

end
