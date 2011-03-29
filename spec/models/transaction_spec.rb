# == Schema Information
#
# Table name: transactions
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

describe Transaction do
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
    Transaction.create!(@valid_attributes)
  end

  it "should calculate a new balance based on the previous" do
    account = Factory(:account)
    Factory(:transaction, :account => account, :amount => 100, :debit => false, :balance => 100)
    Factory(:transaction, :account => account, :amount => 40, :debit => true)
    account.transactions.reload
    account.current_balance.should == 60;
  end

end
