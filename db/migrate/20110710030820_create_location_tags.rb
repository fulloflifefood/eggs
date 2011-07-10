class CreateLocationTags < ActiveRecord::Migration
  def self.up
    create_table :location_tags do |t|
      t.string :name
      t.integer :farm_id

      t.timestamps
    end
  end

  def self.down
    drop_table :location_tags
  end
end
