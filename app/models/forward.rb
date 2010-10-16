class Forward < ActiveRecord::Base
  belongs_to :domain
  
  before_validation(:if => :destination_changed?) {|forward| forward.destination=forward.destination}
  
  validates_presence_of :name, :domain_id, :destination  
  
  scope :active, where(:active => true)
  scope :ordered, order("active DESC, name ASC")
  scope :domain_id, lambda { |domain_id| where(:domain_id => domain_id)}
  scope :name_like, lambda { |name| where("forwards.name LIKE ?", "%#{name}%") } 
  
  def self.search(params={})
     scope = includes(:domain)
     scope = scope.name_like(params[:name_like]) unless params[:name_like].blank?
     scope = scope.domain_id(params[:domain_id]) unless params[:domain_id].blank?
     scope.ordered
   end
  

  def to_s
    domain ? "#{name}@#{domain}" : name
  end
  
  def destination=(dest)
    dest = dest + '@' + domain.name unless (domain.blank? || dest =~ /@/) 
    write_attribute :destination, dest
  end
end
