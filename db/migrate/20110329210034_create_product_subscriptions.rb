class CreateProductSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.integer :product_id
      t.integer :account_id

      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
