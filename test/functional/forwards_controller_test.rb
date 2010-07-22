require 'test_helper'

class ForwardsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Forward.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Forward.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Forward.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to forward_url(assigns(:forward))
  end
  
  def test_edit
    get :edit, :id => Forward.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Forward.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Forward.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Forward.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Forward.first
    assert_redirected_to forward_url(assigns(:forward))
  end
  
  def test_destroy
    forward = Forward.first
    delete :destroy, :id => forward
    assert_redirected_to forwards_url
    assert !Forward.exists?(forward.id)
  end
end
