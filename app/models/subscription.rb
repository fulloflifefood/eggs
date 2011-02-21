# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer(4)      not null, primary key
#  member_id  :integer(4)
#  farm_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Subscription < ActiveRecord::Base
  belongs_to :farm
  belongs_to :member
  has_many :transactions

  liquid_methods :member, :farm

  def after_create
    self.pending = true
    self.deposit_received = false
    self.joined_mailing_list = false
    self.save!
  end

  def current_balance
    last_transaction = self.transactions.last
    last_transaction ? last_transaction.balance : 0
  end

  def calculate_balance
    self.transactions.all.inject(0) do |total, transaction|
      total + (transaction.debit? ? transaction.amount * -1 : transaction.amount)
    end
  end

  def self.print_balance_diff
    Subscription.all.each do |subscription|
      next if !subscription.member.present?
      current = subscription.current_balance.to_i
      calculated = subscription.calculate_balance.to_i
      diff = current - calculated
      next if diff == 0
      puts "#{subscription.member.last_name}:"
      puts "  diff=#{diff},curr=#{current},calc=#{calculated}"
    end
    nil
  end

end
