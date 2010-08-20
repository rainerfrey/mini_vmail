class User < ActiveRecord::Base
  acts_as_authentic
  attr_protected :admin
  
  def to_s
    login
  end
end
