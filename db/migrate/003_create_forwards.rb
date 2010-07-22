class CreateForwards < ActiveRecord::Migration
  def self.up
    create_table :forwards do |t|
      t.string :name
      t.string :destination
      t.references :domain
      t.boolean :active
      t.text :notes
      t.timestamps
    end
  end
  
  def self.down
    drop_table :forwards
  end
end
