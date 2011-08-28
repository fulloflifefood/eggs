class AccountTransactionsController < ApplicationController

  include ActiveMerchant::Billing::Integrations

  skip_before_filter :authenticate, :only => [:ipn] 
  protect_from_forgery :except => [:ipn]

  access_control do
    allow :admin, :of => @farm
    allow :member, :to => [:show, :index]
    allow all, :to => "ipn"
  end

  def index
    @member = Member.find(params[:member_id])
    @account = Account.find_by_member_id_and_farm_id(params[:member_id], @farm.id)
    @account_transactions = @account.account_transactions

    balance_snippet = Snippet.find_by_identifier_and_farm_id('balance_details', @farm.id)
    @balance_template = Liquid::Template.parse(balance_snippet.body) if balance_snippet

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @account_transactions }
    end
  end

  # GET /account_transactions/1
  # GET /account_transactions/1.xml
  def show
    @account_transaction = AccountTransaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account_transaction }
    end
  end

  # GET /account_transactions/new
  # GET /account_transactions/new.xml
  def new
    @account_transaction = AccountTransaction.new
    @account = Account.find_by_member_id_and_farm_id(params[:member_id], @farm.id)
    @member = @account.member

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account_transaction }
    end
  end

  # GET /account_transactions/1/edit
  def edit
    @account_transaction = AccountTransaction.find(params[:id])
  end

  # POST /account_transactions
  # POST /account_transactions.xml
  def create
    @account_transaction = AccountTransaction.new(params[:account_transaction])

    respond_to do |format|
      if @account_transaction.save
        flash[:notice] = 'AccountTransaction was successfully created.'
        @account_transaction.deliver_credit_notification! if !@account_transaction.debit
        format.html { redirect_to :action => "index", :member_id => params[:member_id], :farm_id => params[:farm_id] }
        format.xml  { render :xml => @account_transaction, :status => :created, :location => @account_transaction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account_transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /account_transactions/1
  # PUT /account_transactions/1.xml
  def update
    @account_transaction = AccountTransaction.find(params[:id])

    respond_to do |format|
      if @account_transaction.update_attributes(params[:account_transaction])
        flash[:notice] = 'AccountTransaction was successfully updated.'
        format.html { redirect_to(@account_transaction) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account_transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /account_transactions/1
  # DELETE /account_transactions/1.xml
  def destroy
    @account_transaction = AccountTransaction.find(params[:id])
    @account_transaction.destroy

    respond_to do |format|
      format.html { redirect_to(account_transactions_url) }
      format.xml  { head :ok }
    end
  end

  def ipn
    notify = Paypal::Notification.new(request.raw_post)
    @farm = Farm.find_by_paypal_address(params[:business])


    # we must make sure this account_transaction id is not already completed
    if !AccountTransaction.count("*", :conditions => ["paypal_transaction_id = ?", notify.transaction_id]).zero?
      Notifier.admin_notification({:subject => 'Duplicate AccountTransaction Attempt',
                                          :body => <<EOS 
This PayPal payment has previously been entered and is being ignored.
Probably nothing to worry about - I'm just sending a notification for everything right now.

  Paypal Transaction ID: #{notify.transaction_id}
  Payer Email Address: #{params[:payer_email]}
  Sent to Business: #{params[:business]}
  Amount: $#{notify.amount}
EOS
}, @farm).deliver
      return
    end

    if notify.item_id != '' && notify.item_id != nil
      account = Account.find(notify.item_id)
    else

      if params[:custom] && Account.exists?(:id => params[:custom].to_i)
        account = Account.find(params[:custom].to_i)
        member = account.member
      elsif Member.exists?(:email_address => params[:payer_email])
        member = Member.find_by_email_address(params[:payer_email].downcase)
        account = member.account_for_farm(@farm)
      elsif Member.exists?(:alternate_email => params[:payer_email].downcase)
        member = Member.find_by_alternate_email(params[:payer_email].downcase)
        account = member.account_for_farm(@farm)
      else
        Notifier.admin_notification({:subject => 'PayPal payment from unknown member',
           :body => <<EOS 
Unable to locate member for Paypal Transaction:

  Paypal Transaction ID: #{notify.transaction_id}
  Payer Email Address: #{params[:payer_email]}
  Payer Name: #{params[:first_name]} #{params[:last_name]}
  Sent to Business: #{params[:business]}
  Amount: $#{notify.amount}

  Memo: #{params[:memo]}
  Custom: #{params[:custom]}
EOS
},@farm).deliver

        return
      end
    end

    if notify.acknowledge
      begin
        if notify.complete?
          account_transaction = account.account_transactions.create(:date => Date.today,
                                           :amount => notify.amount,
                                           :paypal_transaction_id => notify.transaction_id,
                                           :debit => false,
                                           :description => "Paypal payment #{notify.transaction_id}"
                                           )

          account_transaction.deliver_credit_notification!
        else
           #Reason to be suspicious
            Notifier.admin_notification({:subject => 'Unusual PayPal notification ',
              :body => <<EOS
This PayPal payment wasn't able to be added.  Maybe it's not complete?:

  Paypal Transaction ID: #{notify.transaction_id}
  Payer Email Address: #{params[:payer_email]}
  Sent to Business: #{params[:business]}
  Amount: $#{notify.amount}
EOS
              },@farm).deliver
        end

      rescue => e
        #Houston we have a bug
      ensure
        #make sure we logged everything we must
      end
    else #account_transaction was not acknowledged
Notifier.admin_notification({:subject => 'Suspicious Paypal Notification',
              :body => <<EOS
This PayPal notification doesn't seem to be verified by PayPal and has not been entered.
Double check the validity of the payment before entering manually.

  Paypal Transaction ID: #{notify.transaction_id}
  Payer Email Address: #{params[:payer_email]}
  Sent to Business: #{params[:business]}
  Amount: $#{notify.amount}
EOS
              },@farm).deliver
    end

    render :nothing => true
  end




end
