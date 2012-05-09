require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "authlogic/test_case"
require 'turn'


class ActiveSupport::TestCase
  include Authlogic::TestCase
  
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  
  # Add more helper methods to be used by all tests here...
  delegate :debug, :info, :warn, :error, :to => "Rails.logger"
  
  # Add more helper methods to be used by all tests here...
  def login_as(user)
    UserSession.create(users(user))
  end
  
  def with_admin_session
#  login_as :admin
    activate_authlogic
    UserSession.create(users(:admin))
  end
end
