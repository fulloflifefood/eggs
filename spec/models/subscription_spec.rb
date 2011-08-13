require 'spec_helper'

describe Subscription do

  it "should belong to an account and a product" do
    subscription = Subscription.new(:product => Factory(:product), :account => Factory(:account))
    subscription.save.should == true
    subscription.account.should == Account.first
    subscription.product.should == Product.first
  end

  it "should have an array of subscription_transactions" do
    subscription = Subscription.new(:product => Factory(:product), :account => Factory(:account))
    subscription.subscription_transactions.size.should == 0
  end
end
