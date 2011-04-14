class SubscriptionTransactionsController < ApplicationController

  protect_from_forgery

  access_control do
    allow :admin
    allow :member, :to => [:show, :index]
  end


  def index
    @subscription_transactions = SubscriptionTransaction.find_all_by_subscription_id(params[:subscription_id])
    @subscription = Subscription.find(params[:subscription_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subscription_transactions }
    end
  end


  # GET /subscription_transactions/new
  # GET /subscription_transactions/new.xml
  def new
    @subscription_transaction = SubscriptionTransaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subscription_transaction }
    end
  end

  def new_many

    @subscriptions = Subscription.find_all_by_product_id(params[:product_id])

    @subscription_transactions = Array.new
    @subscriptions.each do |subscription|
      @subscription_transactions << SubscriptionTransaction.new(:subscription_id => subscription.id, :debit => true)
    end

  end


  # POST /subscription_transactions
  # POST /subscription_transactions.xml
  def create
    @subscription_transaction = SubscriptionTransaction.new(params[:subscription_transaction])

    respond_to do |format|
      if @subscription_transaction.save
        format.html { redirect_to(@subscription_transaction, :notice => 'Subscription transaction was successfully created.') }
        format.xml  { render :xml => @subscription_transaction, :status => :created, :location => @subscription_transaction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subscription_transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  def create_many
    raise
    
  end

  # PUT /subscription_transactions/1
  # PUT /subscription_transactions/1.xml
  def update
    @subscription_transaction = SubscriptionTransaction.find(params[:id])

    respond_to do |format|
      if @subscription_transaction.update_attributes(params[:subscription_transaction])
        format.html { redirect_to(@subscription_transaction, :notice => 'Subscription transaction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subscription_transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  
end
