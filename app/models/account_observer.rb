class AccountObserver < ActiveRecord::Observer
  def after_create(account)
    account.location_tags << account.farm.location_tags
  end
end
