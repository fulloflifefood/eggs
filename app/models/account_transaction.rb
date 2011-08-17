# == Schema Information
#
# Table name: account_transactions
#
#  id              :integer(4)      not null, primary key
#  date            :date
#  amount          :float
#  description     :string(255)
#  member_id       :integer(4)
#  order_id        :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  debit           :boolean(1)
#  balance         :float
#  account_id :integer(4)
#

class AccountTransaction < ActiveRecord::Base
  belongs_to :account
  belongs_to :order

  before_create :zero_nil_amount

  before_create do
    calculate_balance self.account.account_transactions.last
  end

  liquid_methods :amount, :description, :paypal_transaction_id, :debit, :balance,
                 :account

  after_initialize do
    self.debit = false if !self.debit
  end

  def zero_nil_amount
    self.amount = 0 if self.amount == nil
  end

  def calculate_balance(previous_transaction)
    if previous_transaction
      self.balance = previous_transaction.balance + (debit ? -amount : amount)
    else
      self.balance = debit ? -amount : amount
    end
  end

  def deliver_credit_notification!
    template = EmailTemplate.find_by_identifier_and_farm_id("transaction_notification", self.account.farm.id)
    template.deliver_to(self.account.member.email_address, :account_transaction => self) if template
  end

end
