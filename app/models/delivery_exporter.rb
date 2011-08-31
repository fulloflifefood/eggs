class DeliveryExporter < ActiveRecord::Base
  def self.get_csv(delivery, tabs = false, by_location = false)
    # headers: last name, first name, email, cell, location, stock_item, notes, balance, bag total, new balance, how paid, last_name

    col_sep = tabs ? "\t" : ","

    csv_string = FasterCSV.generate(:col_sep => col_sep) do |csv|

      csv << "#{delivery.pretty_date} - #{delivery.name}"

      delivery.locations.each do |location|
        csv << ["#{location.name} - #{location.host_name}", location.address, "#{location.host_email} - #{location.host_phone}"]
      end
      csv << [' ']


      if by_location
        delivery.locations.each do |location|
          csv << [location.name]
          csv << self.get_headers(delivery, by_location)
          csv << self.get_totals(delivery, location)

          delivery.orders.for_location(location).each do |order|
            row = self.get_order_row(order, by_location)
            csv << row
          end
          csv << [' ']
        end
      else
        csv << self.get_headers(delivery)
        csv << self.get_totals(delivery)

        delivery.orders.each do |order|
          row = self.get_order_row(order)
          csv << row
        end
      end

    end
  end

  def self.get_xls(delivery, tabs = false, by_location = false)
    csv_str = self.get_csv(delivery, tabs, by_location)

    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => "#{delivery.name} - #{delivery.pretty_date}"

    csv_rows = FasterCSV.parse(csv_str)

    csv_rows.each_with_index do |row, i|
      row.each_with_index do |field, j|
        sheet.row(i).push field
      end
    end

    return book

  end

  def self.get_headers(delivery, by_location = false)
    headers = ["Last Name", "First Name", "Email", "Cell Phone"]
    headers << "Location" if !by_location
    delivery.stock_items.with_quantity.each {|item| headers << "#{item.product_name} - #{item.product_price_code}"}
    delivery.delivery_questions.visible.each {|question| headers << question.short_code }
    headers += ["Notes", "Estimated Total", "Bag Total", "Balance", "How Paid", "Last Name"]
    headers
  end

  def self.get_totals(delivery, location = nil)
    totals = [' ',' ',' ',' ']
    totals << ' ' if location == nil
    delivery.stock_items.with_quantity.each do |item|
      totals << (location ? item.quantity_ordered_for_location(location) : item.quantity_ordered)
    end
    totals
  end

  def self.get_order_row(order, by_location = false)
    account = order.member.accounts.select{|item| item.farm.name == order.delivery.farm.name}.first
    row = [order.member.last_name, order.member.first_name, order.member.email_address, order.member.phone_number]
    row << order.location.name if !by_location
    order.order_items.with_stock_quantity.each{ |item| row << item.quantity }
    order.order_questions.visible.each {|question| row << question.option_code }
    row += [order.notes, order.estimated_total.round(2), order.finalized_total, account.current_balance, nil, order.member.last_name]
    row
  end
end
