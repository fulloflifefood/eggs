class AddLocationTagIdToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :location_tag_id, :integer
  end

  def self.down
    remove_column :locations, :location_tag_id
  end
end
