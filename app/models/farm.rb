# == Schema Information
#
# Table name: farms
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  key           :string(255)
#  paypal_link   :string(255)
#  contact_email :string(255)
#  contact_name  :string(255)
#

class Farm < ActiveRecord::Base
  validates_presence_of :name
  has_many :products, :order => 'position', :dependent => :destroy
  has_many :deliveries, :dependent => :destroy
  has_many :accounts, :dependent => :destroy
  has_many :members, :through => :accounts, :order => 'last_name, first_name', :include => [:user,:accounts], :readonly => false
  has_many :locations, :dependent => :destroy
  has_many :location_tags, :dependent => :destroy
  has_many :email_templates, :dependent => :destroy
  has_many :product_questions, :dependent => :destroy
  has_many :snippets, :dependent => :destroy

  acts_as_authorization_object

  liquid_methods :name, :contact_email, :contact_name, :paypal_link, :subdomain, :address, :mailing_list_subscribe_address

  def self.find_by_paypal_address(address)
    Farm.all.each do |farm|
      return farm if farm.has_paypal_address?(address)
    end
    nil
  end

  # TODO: Figure out why this relationship is broken!
  def users
    user_arr = []
    accounts.each do |s|
      user_arr << User.find(s.user.id)
    end
    user_arr
  end

  def has_paypal_address?(address)
    paypal_account.split(",").include?(address)
  end

  def default_paypal_address
    paypal_account.split(",").first
  end

  def clone_farm
    farm = self.clone
    count = Farm.count + 1
    farm.name = self.name + " Copy #{count}"
    farm.subdomain = self.subdomain + "_#{count}"
    farm.key = self.subdomain + "_#{count}"
    farm.save

    self.email_templates.each do |template|
      farm.email_templates << template.clone
    end

    self.snippets.each do |snippet|
      farm.snippets << snippet.clone
    end

    self.location_tags.each do |location_tag|
      farm.location_tags << location_tag.clone
    end

    self.locations.each do |location|
      new_location = location.clone
      tag = LocationTag.find_or_create_by_farm_id_and_name(farm.id, location.location_tag.name)
      new_location.location_tag = tag
      farm.locations << new_location
    end


    farm

  end

end
