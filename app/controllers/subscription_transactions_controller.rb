class SubscriptionTransactionsController < ApplicationController

  protect_from_forgery

  access_control do
    allow :admin
    allow :member, :to => [:show, :index]
  end


  def index
    @subscription_transactions = SubscriptionTransaction.find_all_by_subscription_id(params[:subscription_id])
    @subscription = Subscription.find(params[:subscription_id])
    @subscription_transaction = SubscriptionTransaction.new

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
    @product_id = params[:product_id]
    @subscriptions = Subscription.find_all_by_product_id(@product_id)

    @subscription_transactions = Array.new
    @subscriptions.each do |subscription|
      @subscription_transactions << SubscriptionTransaction.new(:subscription_id => subscription.id, :debit => true)
    end

  end


  # POST /subscription_transactions
  # POST /subscription_transactions.xml
  def create
    @subscription_transaction = SubscriptionTransaction.new(params[:subscription_transaction])

    if @subscription_transaction.save
      render :json => {:data => @subscription_transaction, :status => "success"}
    else
      render :json => {:data => @subscription_transaction, :status => "error", :errors => @subscription_transaction.errors.full_messages.join("<br/>")}
    end
  end

  def create_many
    @subscription_transactions = []
    params["subscription_transactions"].each do |transaction|
      @subscription_transactions << SubscriptionTransaction.new(transaction)
    end

    description = params["description"]
    date = params["date"]
    @product_id = params["product_id"]
    @subscriptions = Subscription.find_all_by_product_id(@product_id)
    



    respond_to do |format|
      total_saved = 0
      
      begin
        ActiveRecord::Base.transaction do

          @subscription_transactions.each do |subscription_transaction|
            subscription_transaction.description = description
            subscription_transaction.date = date
            subscription_transaction.allow_negative_amount(false)
            subscription_transaction.save! if subscription_transaction.amount != 0
            total_saved = total_saved + 1 if subscription_transaction.valid?
          end

        end

      rescue ActiveRecord::RecordInvalid => invalid
        flash[:notice] = invalid.record.errors.full_messages.join("<br/>").html_safe
        puts invalid.record.errors.full_messages
        format.html { render :action => "new_many" }
      else
        flash[:notice] = "#{total_saved} Subscription Transactions were successfully created."
        format.html { redirect_to(subscriptions_url(:farm_id => @farm.id, :product_id => @product_id)) }
      end

    end
    
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
