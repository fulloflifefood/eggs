class DeliveryImporter

  include ActionView::Helpers::NumberHelper


  COL_CATEGORY = 0
  COL_NAME = 1
  COL_PRICE = 2
  COL_SALE = 3
  COL_BOTTOM = 4
  COL_TOP = 5
  COL_UNITS = 6
  COL_STATIC = 7
  COL_QUANTITY = 8
  COL_PERPERSON = 9
  COL_DESC = 10
  COL_NOTES = 11


  def get_stock_item(arr)

    if arr[COL_QUANTITY].to_i <= 0
      return nil
    end

    stock_item = StockItem.new
    stock_item.product_category = arr[COL_CATEGORY]
    stock_item.product_name = "#{arr[COL_CATEGORY]}: #{arr[COL_NAME]}"
    stock_item.quantity_available = arr[COL_QUANTITY]
    stock_item.max_quantity_per_member = arr[COL_PERPERSON] || 3
    stock_item.product_estimated = arr[COL_STATIC] == "yes" ? false : true

    price = arr[COL_PRICE].gsub(/[^0-9.]/, '').to_f

    bottom = arr[COL_BOTTOM]
    if !bottom.nil?
      bottom_num = bottom.to_s.gsub(/[^0-9.]/, '').to_f
      bottom_num = bottom_num.to_i if bottom_num.to_i == bottom_num      
    end

    top = arr[COL_TOP]
    if !top.nil?
      top_num = top.to_s.gsub(/[^0-9.]/, '').to_f
      top_num = top_num.to_i if top_num.to_i == top_num
    end

    units = arr[COL_UNITS] || "lb"

    if stock_item.product_estimated
      if !bottom.nil? && !top.nil?
        medium_num = ((top_num - bottom_num)*.75) + bottom_num
        stock_item.product_price = price * medium_num
        code = "#{number_to_currency price}/#{units}, #{bottom_num}-#{top_num}#{units}"
      elsif !top.nil?
        stock_item.product_price = price * top_num
        code = "#{number_to_currency price}/#{units}, #{top_num}#{units}"
      elsif !bottom.nil?
        stock_item.product_price = price * bottom_num
        code = "#{number_to_currency price}/#{units}, #{bottom_num}#{units}"
      end
      stock_item.product_price_code = code
      stock_item.product_price = stock_item.product_price.to_i
    else
      stock_item.product_price = price
      stock_item.product_price_code = number_to_currency price
    end

    if !arr[COL_DESC].nil? && !arr[COL_NOTES].nil?
      stock_item.product_description = "#{arr[COL_DESC]} - #{arr[COL_NOTES]}"
    else
      stock_item.product_description = arr[COL_DESC] if !arr[COL_DESC].nil?
      stock_item.product_description = arr[COL_NOTES] if !arr[COL_NOTES].nil?
    end
    

    stock_item
  end

end