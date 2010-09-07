class AddTransportToDomain < ActiveRecord::Migration
  def self.up
    add_column :domains, :transport, :string
    Domain.reset_column_information
    Domain.all.each do |d|
      d.transport = APP_CONFIG[:relay_transport]
      d.updated_by = "migration"
      d.save!
    end
  end

  def self.down
    remove_column :domains, :transport
  end
end
