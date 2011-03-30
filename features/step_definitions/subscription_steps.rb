Given /^the product "([^"]*)" is subscribable$/ do |product_name|
  @farm.products << Factory(:product, :subscribable => true, :name => product_name, :farm => @farm)
end

Given /^the member "([^"]*)" has a subscription for "([^"]*)"$/ do |member_last_name, product_name|
  member = Member.find_by_last_name(member_last_name)
  product = Product.find_by_name_and_farm_id(product_name, @farm.id)
  Subscription.create!(:account => member.account_for_farm(@farm), :product => product)
end
