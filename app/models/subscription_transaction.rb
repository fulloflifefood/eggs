class SubscriptionTransaction < ActiveRecord::Base

  belongs_to :subscription

  validates_presence_of :description, :date
  validates_numericality_of :amount, :only_integer => true
  validates_numericality_of :amount, :greater_than => 0, :unless => :allow_negative_amount?, :message => "can't be negative"

  before_create do
    calculate_balance self.subscription.subscription_transactions.last
  end

  def after_initialize
    allow_negative_amount(true)
  end

  def allow_negative_amount(allow)
    @allow_negative = allow
  end

  def allow_negative_amount?
    @allow_negative
  end

  def calculate_balance(previous_transaction)
    if previous_transaction
      self.balance = previous_transaction.balance + (debit ? -amount : amount)
    else
      self.balance = debit ? -amount : amount
    end
  end
end
