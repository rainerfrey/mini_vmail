class Forward < ActiveRecord::Base
  belongs_to :domain
  
  before_validation(:if => :destination_changed?) {|forward| forward.destination=forward.destination}
  
  validates_presence_of :name, :domain_id, :destination  
  
  scope :active, where(:active => true)
  scope :ordered, order(:active)
  def to_s
    domain ? "#{name}@#{domain}" : name
  end
  
  def destination=(dest)
    dest = dest + '@' + domain.name unless (domain.blank? || dest =~ /@/) 
    write_attribute :destination, dest
  end
end
