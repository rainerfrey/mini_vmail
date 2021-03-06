require 'test_helper'

class MailboxTest < ActiveSupport::TestCase
  test "mandatory attributes must not be blank" do
    mailbox = Mailbox.new
    assert mailbox.invalid?
    assert mailbox.errors[:name].any?
    assert mailbox.errors[:password].any?
    assert mailbox.errors[:domain].any?
  end
  
  test "name must be a valid email local part" do
    mailbox = mailboxes(:mine)
    orig_name = mailbox.name
    mailbox.name = "rainer@home.mr-frey.de"
    assert mailbox.invalid?
  end
  
  test "name must not contain spaces" do
    mailbox = mailboxes(:mine)
    orig_name = mailbox.name
    mailbox.name = "rainer home.mr-frey.de"
    assert mailbox.invalid?
  end
  
  test "name must be unique within domain" do
    mine = mailboxes(:mine)
    mailbox = Mailbox.new(
      :name => mine.name
    )
    mailbox.domain = domains(:home)
    
    mailbox.password = "secret"
    assert mine.domain.name == "home.mr-frey.de", "fixture reference shoud work"
    assert mailbox.domain.name == "home.mr-frey.de", "domain assignment shoud work"
    assert mailbox.invalid?
    assert (mailbox.errors[:name].join(";") == I18n.translate("activerecord.errors.messages.taken")), "name should be taken"
    
    mailbox.name = "unique"
    assert mailbox.valid?, "different name makes it valid"
    
    mailbox.name = mine.name
    mailbox.domain = domains(:test)
    assert mailbox.valid?, "same name is valid in different domain"
  end
  
  test "password may not be mass-assigned" do
    name = "myname"
    pass = "mypass"
    
    assert_raise ActiveModel::MassAssignmentSecurity::Error do
      mailbox = Mailbox.new(
        :name => name,
        :password => pass
      )
    end
  end
  
  test "password can be mass-assigned via virtual attribute" do
    name = "myname"
    pass = "mypass"

    mailbox = Mailbox.new(
      :name => name,
      :my_password => pass
    )
    assert mailbox.password == pass
  end
  
  test "password needs to be confirmed to be valid" do
    name = "myname"
    pass1 = "mypass"
    pass2 = "otherpass"
    mailbox = Mailbox.new(
      :name => name,
    )
    mailbox.domain = domains(:home)
    mailbox.password = pass1
    assert mailbox.valid?
    mailbox.update_attributes(:my_password =>pass2, :my_password_confirmation => "")
    assert mailbox.invalid?
    message= I18n.translate("activerecord.errors.messages.confirmation", :my_password)
    debug "#{mailbox.errors.to_a} <=> #{message}"
    assert mailbox.errors[:my_password].join('; ') ==message
    
    mailbox.update_attributes(:my_password  => pass2, :my_password_confirmation => pass1)
    assert mailbox.invalid?
    assert mailbox.errors[:my_password].join('; ') == message

    # reset
    mailbox.password = pass1
    assert mailbox.password == pass1
    mailbox.update_attributes(:my_password => pass2, :my_password_confirmation => pass2)
    assert mailbox.valid?
    assert mailbox.password == pass2
  end
end
