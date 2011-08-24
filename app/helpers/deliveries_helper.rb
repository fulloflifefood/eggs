module DeliveriesHelper
  def egg_total_for_location(location)
    stock_items = @delivery.stock_items.with_quantity.select do |stock_item|
      stock_item.product_name.downcase.include? "eggs"
    end

    stock_items.inject(0) {|total, item| total + item.quantity_ordered_for_location(location)}
  end
end
