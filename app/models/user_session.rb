class UserSession < Authlogic::Session::Base
  include ActiveModel::Conversion
  
  def to_key
    id ? [id] : nil
  end
  
  def persisted?
    false
  end
end