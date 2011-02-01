class AddForeignKeys < ActiveRecord::Migration
  def self.up
    add_foreign_key :mailboxes, :domains
    add_foreign_key :forwards, :domains
  end

  def self.down
    remove_foreign_key :mailboxes, :domains
    remove_foreign_key :forwards, :domains
  end
end
