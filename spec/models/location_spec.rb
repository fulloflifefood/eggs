# == Schema Information
#
# Table name: locations
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  host_name   :string(255)
#  host_phone  :string(255)
#  host_email  :string(255)
#  address     :string(255)
#  notes       :text
#  time_window :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  farm_id     :integer(4)
#

require 'spec_helper'

describe Location do

end