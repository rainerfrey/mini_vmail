require 'test_helper'

class MailboxTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Mailbox.new.valid?
  end
end
