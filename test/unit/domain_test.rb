require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Domain.new.valid?
  end
end
