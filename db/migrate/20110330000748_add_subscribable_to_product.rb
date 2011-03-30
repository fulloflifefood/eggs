class AddSubscribableToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :subscribable, :boolean, :default => false
  end

  def self.down
    remove_column :products, :subscribable
  end
end
