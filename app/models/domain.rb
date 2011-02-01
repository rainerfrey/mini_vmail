class Domain < ActiveRecord::Base
  has_many :mailboxes, :inverse_of => :domain
  has_many :forwards, :inverse_of => :domain
  
  validates :name, :presence => true, :uniqueness => true
  validates_presence_of :transport
  
  scope :active, where(:active => true)
  scope :ordered, order("active DESC, name ASC")
  scope :name_like, lambda { |name| where("domains.name LIKE ?", "%#{name}%") } 

  def self.search(params={})
    scope=scoped
    scope = scope.name_like(params[:name_like]) unless params[:name_like].blank?
    scope.ordered
  end
  
  def to_s
    name
  end
end
