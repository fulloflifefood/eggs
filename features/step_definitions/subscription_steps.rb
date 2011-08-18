Given /^the product "([^"]*)" is subscribable$/ do |product_name|
  product = Product.find_by_farm_id_and_name(@farm.id, product_name)
  if product
    product.update_attribute("subscribable", true)
  elsif
    @farm.products << Factory(:product, :subscribable => true, :name => product_name, :farm => @farm)
  end
end

Given /^the member "([^"]*)" has a subscription for "([^"]*)"$/ do |member_last_name, product_name|
  member = Member.find_by_last_name(member_last_name)
  product = Product.find_by_name_and_farm_id(product_name, @farm.id)
  Subscription.create!(:account => member.account_for_farm(@farm), :product => product)
end

Given /^the member "([^"]*)" has a "([^"]*)" transaction "([^"]*)" for "([^"]*)"$/ do |member_last_name, product_name, transaction_type, amount|
  subscription = find_subscription(member_last_name, product_name)
  SubscriptionTransaction.create!(:debit => (transaction_type == "debit"),
                                  :amount => amount.to_i,
                                  :subscription => subscription,
                                  :date => Date.today,
                                  :description => "general pickup")
end


def find_subscription(member_last_name, product_name)
  member = Member.find_by_last_name(member_last_name)
  product = Product.find_by_name_and_farm_id(product_name, @farm.id)
  Subscription.find_by_account_id_and_product_id(member.account_for_farm(@farm), product.id)
end

Given /^the member "([^"]*)" has a "([^"]*)" transaction "([^"]*)" for "([^"]*)" from order "([^"]*)"$/ do |member_last_name, product_name, transaction_type, amount, order_id|
  subscription = find_subscription(member_last_name, product_name)
  order = Factory.build(:order, :member => Member.find_by_last_name(member_last_name))
  order.id = order_id
  order.save
  stock_item =  Factory(:stock_item, :product_name => product_name, :product_id => Product.find_by_name(product_name))
  order.order_items << Factory(:order_item, :stock_item => stock_item)
  SubscriptionTransaction.create!(:debit => (transaction_type == "debit"),
                                  :amount => amount.to_i,
                                  :subscription => subscription,
                                  :date => Date.today,
                                  :description => "general pickup",
                                  :order_id => order_id)
end