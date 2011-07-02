class AddTagToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :tag, :string
  end

  def self.down
    remove_column :locations, :tag
  end
end
