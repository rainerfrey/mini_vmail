class Domain < ActiveRecord::Base
  has_many :mailboxes
  has_many :forwards
  
  validates :name, :presence => true, :uniqueness => true
  scope :active, where(:active => true)
  scope :ordered, order("active DESC")
  
  def to_s
    name
  end
end
