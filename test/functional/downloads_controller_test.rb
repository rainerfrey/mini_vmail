require 'test_helper'

class DownloadsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get relay_domains" do
    get :relay_domains
    assert_response :success
  end

end
