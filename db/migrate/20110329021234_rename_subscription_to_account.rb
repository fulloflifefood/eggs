class RenameSubscriptionToAccount < ActiveRecord::Migration
  def self.up
    remove_index :transactions, :subscription_id
    remove_index :subscriptions, :farm_id
    remove_index :subscriptions, :member_id


    rename_table :subscriptions, :accounts

    rename_column :transactions, :subscription_id, :account_id

    add_index :accounts, :farm_id
    add_index :accounts, :member_id
    add_index :transactions, :account_id

  end

  def self.down
    remove_index :accounts, :farm_id
    remove_index :accounts, :member_id
    remove_index :transactions, :account_id

    rename_table :accounts, :subscriptions

    rename_column :transactions, :account_id, :subscription_id

    add_index :subscriptions, :farm_id
    add_index :subscriptions, :member_id
    add_index :transactions, :subscription_id
  end
end
