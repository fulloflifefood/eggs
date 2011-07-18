class CreateAccountLocationTags < ActiveRecord::Migration
  def self.up
    create_table :account_location_tags do |t|
      t.integer :account_id
      t.integer :location_tag_id

      t.timestamps
    end
  end

  def self.down
    drop_table :account_location_tags
  end
end
