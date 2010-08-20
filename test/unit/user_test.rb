require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_admin_protected
    u = User.new(:login => 'test', :email => 'test@test', :password => 'test', :password_confirmation => 'test', :admin => true )
    u.save
    assert !u.admin
  end
end
