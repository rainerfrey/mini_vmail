require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    post :create, :user_session => {login:"admin",password:"wrong"}
    assert !UserSession.find
    assert_template 'new'
  end
  
  def test_create_valid
    post :create, :user_session => {login:"admin",password:"secret"}
    assert UserSession.find
    assert_redirected_to root_url
  end
  
  def test_destroy
    with_admin_session
    user_session = UserSession.find
    delete :destroy
    assert_redirected_to root_url
    assert !UserSession.find
  end
end
