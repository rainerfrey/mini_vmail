require 'test_helper'

class ForwardsControllerTest < ActionController::TestCase
  setup do
    with_admin_session
    @forward = forwards(:remote)
    @invalid = {name: nil}
    @update = {name: "newname", destination: @forward.destination, domain_id: @forward.domain_id}
  end

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
    post :create, :forward => @invalid
    assert_template 'new'
  end
  
  def test_create_valid
    post :create, :forward => @update
    assert_redirected_to forward_url(assigns(:forward))
  end
  
  def test_edit
    get :edit, :id => Forward.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    put :update, :id =>@forward.id, :forward => @invalid
    assert_template 'edit'
  end
  
  def test_update_valid
    put :update, :id =>@forward.id, :forward => @update
    assert_redirected_to forward_url(assigns(:forward))
  end
  
  def test_destroy
    forward = Forward.first
    delete :destroy, :id => forward
    assert_redirected_to forwards_url
    assert !Forward.exists?(forward.id)
  end
end
