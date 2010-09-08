class Domain < ActiveRecord::Base
  has_many :mailboxes
  has_many :forwards
  
  validates :name, :presence => true, :uniqueness => true
  validates_presence_of :transport
  
  scope :active, where(:active => true)
  scope :ordered, order("active DESC, name ASC")
  
  def to_s
    name
  end
end
