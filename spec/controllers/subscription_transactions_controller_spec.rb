require 'spec_helper'

describe SubscriptionTransactionsController do
  render_views

  before(:each) do
    @farm = Factory(:farm)
    activate_authlogic
    UserSession.create Factory(:admin_user)
    UserSession.find.user.has_role!(:admin, @farm)

    @member = UserSession.find.user.member
    @account = Factory(:account, :farm => @farm, :member => @member)

    @product = Factory(:product, :name => "EggShare Eggs", :subscribable => true)
    @accounts = []

    10.times do |i|
      account = Factory(:account, :farm => @farm)
      if i<5
        account.subscriptions << Subscription.new(:product_id => @product.id, :account => account) if i <5
        @accounts << account
      end
    end

  end

  describe "GET new_many" do
    it "makes a list of subscriptions" do
      get :new_many, :product_id=> @product.id, :farm_id => @farm.id
      assigns[:subscriptions].size.should == 5
      assigns[:subscription_transactions].size.should == 5
    end

  end

  describe "POST create_many" do
    it "should create subscription_transactions when listed" do

      @accounts.size.should == 5

      @accounts.each do |account|
        account.subscriptions.first.subscription_transactions << SubscriptionTransaction.new(:amount => 100,
          :subscription_id => account.subscriptions.first.id,
          :debit => false,
          :date => "2011-08-02",
          :description => "Initial Credit")
        account.subscriptions.first.current_balance.should == 100
      end

      post :create_many, "subscription_transactions"=>[
          {"debit"=>"true",
           "amount"=>"3",
           "subscription_id"=>@accounts[0].subscriptions.first.id},
          {"debit"=>"true",
           "amount"=>"0",
           "subscription_id"=>@accounts[1].subscriptions.first.id}],
          "product_id" => @product.id,
          "farm_id" => @farm.id,
          "date" => "2011-08-02",
          "description" => "Ferry Building"


      subscription1 = @accounts[0].subscriptions.first
      subscription2 = @accounts[1].subscriptions.first

      subscription1.current_balance.should == 97
      subscription1.subscription_transactions.size.should == 2
      subscription1.subscription_transactions.last.description.should == "Ferry Building"
      subscription1.subscription_transactions.last.date.should == Date.new(2011,8,2)

      subscription2.current_balance.should == 100
      subscription2.subscription_transactions.size.should == 1

    end
  end

  describe "GET #index" do
    it "should assign the transactions for the subscription" do
      subscription = @accounts.first.subscriptions.first
      subscription.subscription_transactions << Factory(:subscription_transaction, :amount => 3, :subscription => subscription)
      subscription.subscription_transactions << Factory(:subscription_transaction, :amount => 2, :subscription => subscription)

      get :index, :subscription_id => subscription.id, :farm_id => @farm.id

      assigns(:subscription).should == subscription
      assigns(:subscription_transactions).size.should == 2

      save_fixture(html_for('body'), 'subscription_transactions_index.html')

    end
  end

end










