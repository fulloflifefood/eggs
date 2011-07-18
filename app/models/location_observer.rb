class LocationObserver < ActiveRecord::Observer
  def after_create(location)
    members = location.farm.members

    members.each do |member|
      account = member.account_for_farm(location.farm)
      account.location_tags << location.location_tag if !account.location_tags.include?(location.location_tag)
    end
  end
end
