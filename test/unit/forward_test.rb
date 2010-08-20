require 'test_helper'

class ForwardTest < ActiveSupport::TestCase
    def test_local_destination
      local = forwards(:local)
      local.destination='rainer'
      assert_equal(['rainer', local.domain.name].join('@'),local.destination)
    end
end
