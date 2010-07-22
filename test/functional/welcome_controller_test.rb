require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get initial_login" do
    get :initial_login
    assert_response :success
  end

  test "should get create_initial_login" do
    get :create_initial_login
    assert_response :success
  end

end
