class RenameTransactionsToAccountTransactions < ActiveRecord::Migration
  def self.up
    remove_index :transactions, :account_id
    remove_index :transactions, :order_id
    remove_index :transactions, :paypal_transaction_id

    rename_table :transactions, :account_transactions

    add_index :account_transactions, :account_id
    add_index :account_transactions, :order_id
    add_index :account_transactions, :paypal_transaction_id

  end

  def self.down
    remove_index :account_transactions, :account_id
    remove_index :account_transactions, :order_id
    remove_index :account_transactions, :paypal_transaction_id

    rename_table :account_transactions, :transactions

    add_index :transactions, :account_id
    add_index :transactions, :order_id
    add_index :transactions, :paypal_transaction_id

  end
end
