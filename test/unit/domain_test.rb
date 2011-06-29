require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  test "mandatory attributes must not be empty" do
    domain = Domain.new
    assert domain.invalid?
    assert domain.errors[:name].any?
    assert domain.errors[:transport].any?
  end
  
  test "name must be unique" do
    domain = Domain.new(
      :name => domains(:home).name,
      :transport => domains(:home).transport,
    )
    assert domain.invalid?
    assert domain.errors[:name].join(";") == I18n.translate("activerecord.errors.messages.taken")
    
    domain.name = "unique.do.main"
    assert domain.valid?
  end
end
