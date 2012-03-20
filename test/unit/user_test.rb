require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_admin_protected
    assert_raise ActiveModel::MassAssignmentSecurity::Error do
      u = User.new(:login => 'test', :email => 'test@test', :password => 'test', :password_confirmation => 'test', :admin => true )
      u.save
    end
  end
end
