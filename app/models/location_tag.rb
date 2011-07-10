class LocationTag < ActiveRecord::Base
  belongs_to :farm
  validates_presence_of :name, :farm_id
end
