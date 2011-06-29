require 'test_helper'

class DomainsControllerTest < ActionController::TestCase
  setup do
    with_admin_session
    @domain = domains(:home)
    @invalid = {name: nil}
    @update = {name: "new", transport: @domain.transport, active: @domain.active}
  end
  
  test "should get index" do
    get :index
    assert_response :success    
  end

  def test_show
    get :show, :id => Domain.first
    assert_response :success
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    post :create, :domain => @invalid
    assert_template 'new'
  end
  
  def test_create_valid
    post :create, :domain => @update
    assert_redirected_to domain_url(assigns(:domain))
  end
  
  def test_edit
    get :edit, :id => @domain.id
    assert_template 'edit'
  end
  
  def test_update_invalid
    put :update, :id => @domain.id, :domain => @invalid
    assert_template 'edit'
  end
  
  def test_update_valid
    put :update, :id => @domain.id, :domain => @update
    assert_redirected_to domain_url(assigns(:domain))
  end
  
  def test_destroy
    domain = Domain.first
    delete :destroy, :id => domain
    assert_redirected_to domains_url
    assert !Domain.exists?(domain.id)
  end
end
