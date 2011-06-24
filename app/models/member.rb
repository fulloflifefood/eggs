# == Schema Information
#
# Table name: members
#
#  id              :integer(4)      not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email_address   :string(255)
#  phone_number    :string(255)
#  neighborhood    :string(255)
#  joined_on       :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  address         :string(255)
#  alternate_email :string(255)
#  notes           :text
#

class Member < ActiveRecord::Base
  has_many :accounts
  has_many :farms, :through => :accounts
  has_many :orders, :dependent => :destroy, :include => :delivery, :order => 'deliveries.date DESC' do
    def filter_by_farm(farm)
      self.select {|order| order.delivery.farm == farm}
    end
  end

  has_one :user

  validates_presence_of :first_name, :last_name, :email_address, :phone_number
  validates_uniqueness_of :email_address

  liquid_methods :first_name, :last_name, :email_address, :address, :phone_number, :alternate_email,
                 :balance_for_farm, :referral, :deposit_type, :deposit_received, :joined_mailing_list

  after_create do
    self.update_attribute(:joined_on, Date.today) if !joined_on
  end

  before_save :downcase_email_address

  def downcase_email_address
     self.email_address = self.email_address.downcase
  end

  def email_address_with_name
    "\"#{first_name} #{last_name}\" <#{email_address}>"
  end

  def balance_for_farm(farm)
    account = account_for_farm(farm)
    account.current_balance
  end

  def account_for_farm(farm)
    accounts.detect{|account|account.farm_id == farm.id}
  end

  def export_history(farm, start_date, end_date)

    orders = Order.find_all_by_member_id(self.id)
    orders = orders.select{|order| order.delivery.farm == farm}
    orders = orders.select{|order| order.delivery.date > start_date && order.delivery.date < end_date}

    products = []
    farm.products.each {|product| products.push({:id => product.id, :name => product.name, :quantity => 0})}

    total_spent = 0
    orders.each do |order|
      order.order_items.each do |item|
        p = products.select{|product| product[:id] == item.stock_item.product_id}[0]
        p[:quantity] += item.quantity
      end

      total_spent += order.finalized_total if order.finalized_total
    end

    account = self.account_for_farm(farm)
    transactions = Transaction.find_all_by_account_id_and_debit(account.id, false, :conditions => "date #{(start_date..end_date).to_s(:db)}")

    deposited = transactions.inject(0) {|sum, transaction| sum += transaction.amount}


    history = {
            :orders => orders,
            :products => products,
            :spent => total_spent,
            :deposited => deposited
    }


    return history

  end
  
end
