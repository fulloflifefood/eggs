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
  has_many :products, :order => 'position'
  has_many :deliveries
  has_many :accounts
  has_many :members, :through => :accounts, :order => 'last_name, first_name', :include => [:user,:accounts], :readonly => false
  has_many :locations
  has_many :email_templates
  has_many :product_questions

  acts_as_authorization_object

  liquid_methods :name, :contact_email, :contact_name, :paypal_link, :subdomain, :address, :mailing_list_subscribe_address

  def self.find_by_paypal_address(address)
    Farm.all.each do |farm|
      return farm if farm.has_paypal_address?(address)
    end
    return nil
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
    return paypal_account.split(",").include?(address)
  end

  def default_paypal_address
    return paypal_account.split(",").first
  end

  def get_location_tags
    locations.collect{|location| location.tag}.uniq
  end

end
