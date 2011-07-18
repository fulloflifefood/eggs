class LocationTagObserver < ActiveRecord::Observer
  def after_create(location_tag)
    accounts = location_tag.farm.accounts

    accounts.each do |account|
      account.location_tags << location_tag if !account.location_tags.include?(location_tag)
    end
  end
end
