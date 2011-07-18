# == Schema Information
#
# Table name: accounts
#
#  id         :integer(4)      not null, primary key
#  member_id  :integer(4)
#  farm_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Account < ActiveRecord::Base
  belongs_to :farm
  belongs_to :member
  has_many :transactions, :order => 'created_at ASC'

  has_many :account_location_tags
  has_many :location_tags, :through => :account_location_tags

  liquid_methods :member, :farm, :id

  after_create do
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

  # to be executed only in the case of invalid history for some reason,
  # such as a transaction deleted from database directly
  def recalculate_balance_history!
    self.transactions.each_with_index do |transaction, i|
      previous_transaction = i > 0 ? self.transactions.at(i-1) : nil
      transaction.calculate_balance(previous_transaction)
      transaction.save!
    end
    if Rails.env != "test"
      puts "-- recalculated balance history for #{self.member.last_name}"
    end
  end

  def self.print_balance_diff
    Account.all.each do |account|
      next if !account.member.present?
      current = account.current_balance.to_f.round(2)
      calculated = account.calculate_balance.to_f.round(2)
      diff = current - calculated
      next if diff == 0
      puts "#{account.member.last_name}, #{account.member.first_name}:"
      puts account.member.email_address
      puts "account id: #{account.id}"
      puts "  current:    #{current}"
      puts "  calculated: #{calculated}"
      puts "  diff:       #{diff}"
      puts " "
    end
    return nil
  end

  def has_location_tags?(location_tag_list)
    location_tag_list = [location_tag_list] if location_tag_list.class != Array
    location_tag_list.each do |location_tag|
      return true if location_tags.include?(location_tag)
    end
    false
  end

end
