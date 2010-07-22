require 'test_helper'

class ForwardTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Forward.new.valid?
  end
end
