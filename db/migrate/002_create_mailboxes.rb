class CreateMailboxes < ActiveRecord::Migration
  def self.up
    create_table :mailboxes do |t|
      t.string :name
      t.string :password
      t.references :domain
      t.text :notes
      t.boolean :active
      t.timestamps
    end
  end
  
  def self.down
    drop_table :mailboxes
  end
end
