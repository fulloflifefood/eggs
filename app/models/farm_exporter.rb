class FarmExporter < ActiveRecord::Base
  def self.get_csv(farm, report_year, tabs = false)
    # headers: last name, first name, email, cell, location, stock_item, notes, balance, bag total, new balance, how paid, last_name


    # headers: last name, first name, amount deposited, amount spent, stock_item[n]
    
    col_sep = tabs ? "\t" : ","

    csv_string = FasterCSV.generate(:col_sep => col_sep) do |csv|

      csv << "#{farm.name} - #{report_year}"

      headers = ["Last Name", "First Name", "Amount Deposited", "Amount Spent"]
      farm.products.each {|product| headers << "#{product.name}"}
      csv << headers

      # rows
      farm.members.each do |member|

        member_history = member.export_history(farm, Date.new(report_year), Date.new(report_year+1))

        row = [member.last_name, member.first_name,
               member_history[:deposited], member_history[:spent]]
        farm.products.each do |product|
          p = member_history[:products].select{|prod| prod[:id] == product.id}[0]

          row << p[:quantity]

        end

        csv << row
      end

    end
  end

  def get_member_orders_for_year(member, farm, year)
    member.orders.select do |order|
      order.delivery.date.year == year && order.delivery.farm == farm
    end
  end

end
