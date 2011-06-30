require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  setup do
    User.delete_all
#    activate_authlogic
  end
  
  test "should get index" do
    get :index
    assert_redirected_to controller: "welcome", action: "initial_login"
  end
  
  test "should get initial_login" do
    get :initial_login
    assert_response :success
  end

  test "should create initial_login" do
    assert_difference 'User.count' do
      post :create_initial_login, :user => {login: "admin", email: "admin@example.org", password: "secret", password_confirmation: "secret"}
    end
    assert_redirected_to users_path
  end
end
