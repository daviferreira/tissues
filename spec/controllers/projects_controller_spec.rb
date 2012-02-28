require 'spec_helper'

describe ProjectsController do
  
  describe "as a signed-in user" do
    
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }

    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show'
        response.should be_success
      end
    end

    describe "GET 'new'" do
      it "returns http success" do
        get 'new'
        response.should be_success
      end
    end
    
    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit'
        response.should be_success
      end
    end

    describe "POST 'create'" do
      it "returns http success" do
        #post 'create'
        pending "Test post create"
      end
    end

    describe "PUT 'update'" do
      it "returns http success" do
        #put 'update'
        pending "Test put update"
      end
    end

    describe "POST 'destroy'" do
      it "returns http success" do
        #post 'destroy'
        pending "Test post destroy"
      end
    end
  
  end
  
  describe "as a non signed-in user" do
  
    describe "GET 'index'" do
      it "redirects to the sign in path" do
        get 'index'
        response.should redirect_to new_user_session_path
      end
    end

    describe "GET 'show'" do
      it "redirects to the sign in path" do
        get 'show'
        response.should redirect_to new_user_session_path
      end
    end

    describe "GET 'new'" do
      it "redirects to the sign in path" do
        get 'new'
        response.should redirect_to new_user_session_path
      end
    end
    
    describe "GET 'edit'" do
      it "redirects to the sign in path" do
        get 'edit'
        response.should redirect_to new_user_session_path
      end
    end

    describe "POST 'create'" do
      it "redirects to the sign in path" do
        post 'create'
        response.should redirect_to new_user_session_path
      end
    end
    
    describe "PUT 'update'" do
      it "redirects to the sign in path" do
        put 'update'
        response.should redirect_to new_user_session_path
      end
    end
    
    describe "POST 'destroy'" do
      it "redirects to the sign in path" do
        post 'destroy'
        response.should redirect_to new_user_session_path
      end
    end    
  
  end

end
