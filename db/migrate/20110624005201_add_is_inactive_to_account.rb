class AddIsInactiveToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :is_inactive, :boolean, :default => false
    Account.update_all ["is_inactive = ?", false]
  end

  def self.down
    remove_column :accounts, :isInactive
  end
end
