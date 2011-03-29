Given /^the member "([^\"]*)" is pending$/ do |last_name|
  member = Member.find_by_last_name(last_name)
  account = member.account_for_farm(@farm)
  account.pending = true
  account.save!
end

Given /^the member "([^\"]*)" has the email address "([^\"]*)"$/ do |name, email|
  last_name = name.split(" ").last
  member = Member.find_by_last_name(last_name)
  user = User.find_by_member_id(member.id)
  user.email = email

  user.save!
end


Given /^I have a balance of "([^\"]*)"$/ do |balance|
  account = @user.member.account_for_farm(@farm)
  transaction = Transaction.new(:amount => balance)
  account.transactions << transaction

end