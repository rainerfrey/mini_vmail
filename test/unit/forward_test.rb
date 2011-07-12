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

end
