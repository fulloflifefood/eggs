# == Schema Information
#
# Table name: members
#
#  id              :integer(4)      not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email_address   :string(255)
#  phone_number    :string(255)
#  neighborhood    :string(255)
#  joined_on       :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  address         :string(255)
#  alternate_email :string(255)
#  notes           :text
#

require 'spec_helper'

describe Member do
  before(:each) do
    @valid_attributes = {
      :first_name => "Timothy",
      :last_name => "Riggins",
      :email_address => "tim@riggins.net",
      :phone_number => "512-353-3694",
      :neighborhood => "dillon"
    }
  end

  it "should create a new instance given valid attributes" do
    Member.create!(@valid_attributes)
  end

  it "should return only the orders for a specific farm" do
    member = Factory(:member_with_orders_from_2_farms)
    member.orders.size.should == 2
    member.orders.filter_by_farm(member.farms.first).size.should == 1
  end

  it "can return the balance for an account given a farm" do
    farm = Factory(:farm_with_members)
    member = farm.members.first
    member.accounts.size.should == 1

    account_transaction = AccountTransaction.new(:account => member.accounts.first,
                    :amount => 90, :debit => true)
    
    account_transaction.save.should == true
    member.accounts.first.current_balance.should == -90
    member.balance_for_farm(farm).should == -90

  end

  it "ensures email_address is unique" do
    Factory.create(:member, :email_address => "one@two.com")
    second_member = Factory.build(:member, :email_address => "one@two.com")
    second_member.valid?.should == false
  end

  it "ensures email_address is lowercase" do
    member = Factory.create(:member, :email_address => "HELLO@example.COM")
    member.email_address.should == "hello@example.com"
  end

  it "has one user" do
    member = Factory.create(:member)
    user = Factory.create(:user, :member => member)

    member.user.should == user

  end

  it "can return whether or not it has an order for a specific delivery" do
    member = Factory(:member_with_orders_from_2_farms)
    delivery = member.orders.last.delivery

    member.has_order_for_delivery?(delivery).should == true
    member.has_order_for_delivery?(Factory(:delivery)).should == false


  end

  it "assigns the joined_on date to today if not already specified" do
    member = Factory.build(:member)
    member.save!
    member.joined_on.should == Date.today

    date = Date.parse('Mon, 22 Mar 2010')
    member_with_joined_on = Factory.build(:member, :joined_on => date)
    member_with_joined_on.save!
    member_with_joined_on.joined_on.should == date

  end

  it "can export order history for a specified farm and timeframe" do
    farm = Factory(:farm)
    farm.members << Factory(:member)
    member = farm.members.first
    account = member.accounts.first

    farm.products << Factory(:product, :name => "Chicken", :farm => farm)
    farm.products << Factory(:product, :name => "Eggs", :farm => farm)

    # credits
    make_transaction(account, false, 100, Date.new(2010, 4, 1))
    make_transaction(account, false, 100, Date.new(2010, 5, 1))
    make_transaction(account, false, 100, Date.new(2009, 3, 1))
    make_transaction(account, false, 100, Date.new(2011, 4, 1))

    # debits
    make_transaction(account, true, 40, Date.new(2010, 4, 15))
    make_transaction(account, true, 30, Date.new(2010, 6, 1))
    make_transaction(account, true, 50, Date.new(2009, 10, 4))
    make_transaction(account, true, 20, Date.new(2011, 1, 2))

    delivery1 = Factory(:delivery, :farm => farm, :date => '2010-01-27')
    delivery2 = Factory(:delivery, :farm => farm, :date => '2010-02-27')
    delivery3 = Factory(:delivery, :farm => farm, :date => '2009-01-27')
    delivery4 = Factory(:delivery, :farm => farm, :date => '2011-01-27')

    delivery1.stock_items << Factory(:stock_item, :product => farm.products.first, :delivery => delivery1)
    delivery1.stock_items << Factory(:stock_item, :product => farm.products.last, :delivery => delivery1)

    delivery2.stock_items << Factory(:stock_item, :product => farm.products.first, :delivery => delivery2)
    delivery2.stock_items << Factory(:stock_item, :product => farm.products.last, :delivery => delivery2)

    delivery3.stock_items << Factory(:stock_item, :product => farm.products.first, :delivery => delivery3)
    delivery3.stock_items << Factory(:stock_item, :product => farm.products.last, :delivery => delivery3)

    delivery4.stock_items << Factory(:stock_item, :product => farm.products.first, :delivery => delivery4)
    delivery4.stock_items << Factory(:stock_item, :product => farm.products.last, :delivery => delivery4)




    order1 = Order.new_from_delivery(delivery1)
    order2 = Order.new_from_delivery(delivery2)
    order3 = Order.new_from_delivery(delivery3)
    order4 = Order.new_from_delivery(delivery4)
    order1.member = order2.member = order3.member = order4.member = member
    order1.location = order2.location = order3.location = order4.location = Factory(:location)
    order1.delivery = delivery1
    order2.delivery = delivery2
    order3.delivery = delivery3
    order4.delivery = delivery4

    order1.order_items.first.quantity = 3
    order1.order_items.last.quantity = 3

    order2.order_items.first.quantity = 2
    order2.order_items.last.quantity = 1

    order3.order_items.first.quantity = 3
    order3.order_items.last.quantity = 3

    order4.order_items.first.quantity = 3
    order4.order_items.first.quantity = 3

    order1.finalized_total = 36.36
    order2.finalized_total = 42.42
    order3.finalized_total = 30.50
    order4.finalized_total = 30.56

    order1.save!
    order2.save!
    order3.save!
    order4.save!
    
    farm.products.size.should == 2
    farm.members.size.should == 1

    member.orders.size.should == 4

    member_history = member.export_history(farm, Date.new(2010), Date.new(2011))

    member_history[:orders].size.should == 2
    member_history[:products].size.should == 2
    member_history[:products].first[:quantity].should == 5
    member_history[:products].last[:quantity].should == 4
    member_history[:deposited].should == 200
    member_history[:spent].should == 78.78

        
  end

  def make_transaction(account, debit, amount, date)
    AccountTransaction.new(:account => account, :amount => amount, :debit => debit, :date => date).save!

  end
end
