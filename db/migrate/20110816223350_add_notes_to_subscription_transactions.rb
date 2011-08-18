class AddNotesToSubscriptionTransactions < ActiveRecord::Migration
  def self.up
    add_column :subscription_transactions, :notes, :string
  end

  def self.down
    remove_column :subscription_transactions, :notes
  end
end
