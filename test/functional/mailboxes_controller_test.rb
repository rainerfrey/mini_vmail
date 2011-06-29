require 'test_helper'

class MailboxesControllerTest < ActionController::TestCase
  setup do
    @mailbox = mailboxes(:mine)
    @update = {name: "newuser", my_password: "secret", my_password_confirmation: "secret", domain_id: @mailbox.domain_id}
    @invalid = {name: nil}
    with_admin_session
  end

  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Mailbox.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    post :create, :mailbox => @invalid
    assert_template 'new'
  end
  
  def test_create_valid
    post :create, :mailbox => @update
    assert_redirected_to mailbox_url(assigns(:mailbox))
  end
  
  def test_edit
    get :edit, :id => Mailbox.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    put :update, :id => @mailbox.id, :mailbox => @invalid
    assert_template 'edit'
  end
  
  def test_update_valid
    put :update, :id => @mailbox.id, :mailbox => @update
    assert_redirected_to mailbox_url(assigns(:mailbox))
  end
  
  def test_destroy
    mailbox = Mailbox.first
    delete :destroy, :id => mailbox
    assert_redirected_to mailboxes_url
    assert !Mailbox.exists?(mailbox.id)
  end
end
