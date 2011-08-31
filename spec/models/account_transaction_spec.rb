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

require 'spec_helper'

describe AccountTransaction do
  before(:each) do
    @valid_attributes = {
      :date => Date.today,
      :amount => 1.5,
      :description => "value for description",
      :account_id => Factory(:account).id,
      :balance => 10,
      :debit => true
    }
  end

  it "should create a new instance given valid attributes" do
    AccountTransaction.create!(@valid_attributes)
  end

  describe "Calculating Balance" do
    before(:each) do
      @account = Factory(:account)
      Factory(:account_transaction, :account => @account, :amount => 100, :debit => false, :balance => 100)
      Factory(:account_transaction, :account => @account, :amount => 40, :debit => true)
    end
    it "should calculate a new balance based on the previous" do
      @account.account_transactions.reload
      @account.current_balance.should == 60;
    end

    it "should round balances to nearest cent" do
      Factory(:account_transaction, :account => @account, :amount => 10.00000001, :debit => true)
      @account.current_balance.should == 50.00;
    end
  end

end
