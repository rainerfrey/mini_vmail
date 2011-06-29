require 'test_helper'

class ForwardTest < ActiveSupport::TestCase
    def test_local_destination
      local = forwards(:local)
      local.destination='rainer'
      assert_equal(['rainer', local.domain.name].join('@'),local.destination)
    end

    test "remote destination must not have forward's domain name appended" do
      forward = forwards(:remote)
      forward.destination = "frey.rainer@gmail.com"
      assert_equal("frey.rainer@gmail.com", forward.destination)
    end
    
    test "mandatory attributes must not be blank" do
      forward = Forward.new
      assert forward.invalid?
      assert forward.errors[:name].any?
      assert forward.errors[:destination].any?
      assert forward.errors[:domain].any?
    end

    # test "name must be unique within domain" do
    #   local = forwards(:local)
    #   forward = Forward.new(
    #     :name => local.name,
    #     :destination => 'rainer@home.mr-frey.de'
    #   )
    #   forward.domain = domains(:home)
    # 
    #   assert forward.domain.name == "home.mr-frey.de", "domain assignment shoud work"
    #   assert forward.invalid?
    #   debug forward.to_yml
    #   debug forward.errors
    #   debug I18n.translate("activerecord.errors.messages.taken")
    #   assert forward.errors[:name].include?(I18n.translate("activerecord.errors.messages.taken")), "name should be taken"
    # 
    #   forward.name = "unique"
    #   assert forward.valid?, "different name makes it valid"
    # 
    #   forward.name = local.name
    #   forward.domain = domains(:test)
    #   assert forward.valid?, "same name is valid in different domain"
    # end
    
end
