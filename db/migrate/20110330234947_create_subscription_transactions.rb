class CreateSubscriptionTransactions < ActiveRecord::Migration
  def self.up
    create_table :subscription_transactions do |t|
      t.float :amount
      t.string :description
      t.integer :order_id
      t.boolean :debit, :default => false
      t.float :balance
      t.integer :subscription_id
      t.date :date

      t.timestamps
    end

    add_index :subscription_transactions, :subscription_id
  end

  def self.down
    remove_index :subscription_transactions, :subscription_id
    drop_table :subscription_transactions
  end
end
