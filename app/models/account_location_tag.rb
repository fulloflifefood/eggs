class AccountLocationTag < ActiveRecord::Base
  belongs_to :account
  belongs_to :location_tag  
end
