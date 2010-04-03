# == Schema Information
#
# Table name: users
#
#  id                :integer         not null, primary key
#  phone_number      :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  username          :string(255)
#  member_id         :integer
#

class User < ActiveRecord::Base
  belongs_to :member
  has_many :roles_users
  has_many :roles, :through => :roles_users

  accepts_nested_attributes_for :member

  validates_presence_of :email

  acts_as_authorization_subject
  acts_as_authentic do |c|
    c.validates_length_of_password_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
    c.validates_length_of_password_confirmation_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
  end


  attr_accessible :email, :password, :password_confirmation, :member_attributes

  # BUG: this doesn't always seem to trigger, so you have to trigger manually after update/create
  before_save :update_member_email

  def update_member_email
    if self.member
      self.member.email_address = self.email
      self.member.save
    end
  end

  def active?
    active
  end

  def activate!(params)
    self.active = true
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    save
  end

  def has_no_credentials?
    self.crypted_password.blank?
  end

  def signup!(params)
    self.email = params[:email]
    self.member = params[:member]
    save_without_session_maintenance
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end


end
