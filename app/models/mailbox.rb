class Mailbox < ActiveRecord::Base
  belongs_to :domain
  scope :active, where(:active => true)
  scope :ordered, order("active DESC, name ASC")
  scope :domain_id, lambda { |domain_id| where(:domain_id => domain_id)}
  scope :name_like, lambda { |name| where("mailboxes.name LIKE ?", "%#{name}%") } 
  
  validates_presence_of :name, :password, :domain_id
  validates_uniqueness_of :name, :scope => :domain_id
  validates_confirmation_of :my_password
  
  attr_protected :password
  
  attr_reader :my_password
  
  def self.search(params={})
    scope = includes(:domain)
    scope = scope.name_like(params[:name_like]) unless params[:name_like].blank?
    scope = scope.domain_id(params[:domain_id]) unless params[:domain_id].blank?
    scope.ordered
  end
  
  def my_password=(pass)
    @my_password=pass
    self.password=pass unless pass.blank?
  end
  
  def to_s
    domain ? "#{name}@#{domain}" : name
  end
end
