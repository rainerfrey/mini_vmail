class Mailbox < ActiveRecord::Base
  belongs_to :domain
  scope :active, where(:active => true)
  scope :ordered, order("active DESC, name ASC")
  
  validates_presence_of :name, :password, :domain_id
  validates_uniqueness_of :name, :scope => :domain_id
  validates_confirmation_of :my_password
  
  attr_protected :password
  
  attr_reader :my_password
  
  def my_password=(pass)
    @my_password=pass
    self.password=pass unless pass.blank?
  end
  
  def to_s
    domain ? "#{name}@#{domain}" : name
  end
end
