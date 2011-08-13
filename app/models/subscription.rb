class Subscription < ActiveRecord::Base
  belongs_to :product
  belongs_to :account

  has_many :subscription_transactions, :order => "created_at ASC"

  def current_balance
    self.subscription_transactions.size > 0 ? self.subscription_transactions.last.balance : 0
  end
end
