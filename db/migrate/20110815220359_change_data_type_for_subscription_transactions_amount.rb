class ChangeDataTypeForSubscriptionTransactionsAmount < ActiveRecord::Migration
  def self.up
    change_table :subscription_transactions do |t|
      t.change :amount, :integer
    end
  end

  def self.down
    change_table :subscription_transactions do |t|
      t.change :amount, :float
    end
  end
end
