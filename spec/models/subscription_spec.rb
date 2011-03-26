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

require 'spec_helper'

describe Subscription do
  before(:each) do
    @valid_attributes = {

    }
  end

  it "should create a new instance given valid attributes" do
    Subscription.create!(@valid_attributes)
  end

  it "should return the current balance based on the last transaction" do
    subscription = Factory(:subscription)

    subscription.current_balance.should == 0

    Factory(:transaction, :amount => 100, :debit => false, :subscription => subscription)
    Factory(:transaction, :amount => 40, :debit => true, :subscription => subscription)

    subscription.current_balance.should == 60
  end

  it "accepts fields pertaining to new membership" do
    subscription = Factory.build(:subscription)
    subscription.deposit_type = "paypal"
    subscription.deposit_received = false
    subscription.joined_mailing_list = false
    subscription.referral = "kathryn aaker"
    subscription.save!
    subscription.pending.should == true
  end

  it "defaults new member fields to pending" do
    subscription = Factory.build(:subscription)
    subscription.pending.should == false
    subscription.deposit_received.should == true
    subscription.joined_mailing_list.should == true
    subscription.save!

    # this is because the database defaults to not pending,
    # but newly created members default to pending = true
    subscription.pending.should == true
    subscription.joined_mailing_list.should == false
    subscription.deposit_received.should == false
  end

  describe "#calculate_balance" do
    before do
      @subscription = Factory(:subscription)

      Factory(:transaction, :amount => 100, :debit => false, :subscription => @subscription)
      transaction = Factory(:transaction, :amount => 40, :debit => true, :subscription => @subscription)
      transaction.update_attribute(:balance, 0)
    end

    it "calculates based on all transactions" do
      @subscription.current_balance.should == 0
      @subscription.calculate_balance.should == 60
    end

  end

  describe "#recalculate_balance_history!" do
    before do
      @subscription = Factory(:subscription)
      
      Factory(:transaction, :amount => 100, :debit => false, :subscription => @subscription).update_attribute(:balance, 0)
      Factory(:transaction, :amount => 40, :debit => true, :subscription => @subscription).update_attribute(:balance, 0)

    end

    it "recalculates and applies correct balances for all transactions" do
      @subscription.current_balance.should == 0
      @subscription.recalculate_balance_history!
      @subscription.current_balance.should == 60

      @subscription.transactions.first.balance.should == 100
      @subscription.transactions.last.balance.should == 60

    end

    it "recalculates and applies correct balances for all transactions when not 0" do
      @subscription.transactions.first.update_attribute(:balance, -50)
      @subscription.transactions.last.update_attribute(:balance, 25)

      @subscription.current_balance.should == 25
      @subscription.recalculate_balance_history!
      @subscription.current_balance.should == 60

      @subscription.transactions.first.balance.should == 100
      @subscription.transactions.last.balance.should == 60

    end
    
  end

end
