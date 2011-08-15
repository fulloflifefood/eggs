class ChangeDataTypeForSubscriptionTransactionBalance < ActiveRecord::Migration
  def self.up
    change_table :subscription_transactions do |t|
      t.change :balance, :integer
    end
  end

  def self.down
    change_table :subscription_transactions do |t|
      t.change :balance, :float
    end
  end
end
