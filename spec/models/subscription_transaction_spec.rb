require 'spec_helper'

describe SubscriptionTransaction do
  before(:each) do
    @farm = Factory(:farm)
    @member = Factory(:user).member
    @account = Factory(:account, :farm => @farm, :member => @member)

    @product = Factory(:product, :name => "EggShare Eggs", :subscribable => true)
    @subscription = Subscription.create(:product_id => @product.id, :account => @account)

  end
  it "should require date and description" do
    subscription_transaction = SubscriptionTransaction.new(:amount => 2, :subscription_id => @subscription.id, :debit => 2)
    subscription_transaction.valid?.should == false
    
    subscription_transaction["date"] = "2011-08-02"
    subscription_transaction["description"] = "Ferry Building"
    subscription_transaction.valid?.should == true
  end
end
