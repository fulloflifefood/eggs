class SubscriptionTransaction < ActiveRecord::Base

  belongs_to :subscription


  before_create do
    calculate_balance self.subscription.subscription_transactions.last
  end

  def calculate_balance(previous_transaction)
    if previous_transaction
      self.balance = previous_transaction.balance + (debit ? -amount : amount)
    else
      self.balance = debit ? -amount : amount
    end
  end
end
