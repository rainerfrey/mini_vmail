class AddCreatedUpdatedBy < ActiveRecord::Migration
  TABLES = [:domains, :mailboxes, :forwards ]
  def self.up
    TABLES.each do |table|
      change_table table do |t|
        t.string :created_by
        t.string :updated_by
      end
    end
  end

  def self.down
    TABLES.each do |table|
      remove_column table, :created_by
      remove_column table, :updated_by
    end
  end
end
