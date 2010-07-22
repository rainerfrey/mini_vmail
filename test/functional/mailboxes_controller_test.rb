require 'test_helper'

class MailboxesControllerTest < ActionController::TestCase
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
    Mailbox.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Mailbox.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to mailbox_url(assigns(:mailbox))
  end
  
  def test_edit
    get :edit, :id => Mailbox.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Mailbox.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Mailbox.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Mailbox.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Mailbox.first
    assert_redirected_to mailbox_url(assigns(:mailbox))
  end
  
  def test_destroy
    mailbox = Mailbox.first
    delete :destroy, :id => mailbox
    assert_redirected_to mailboxes_url
    assert !Mailbox.exists?(mailbox.id)
  end
end
