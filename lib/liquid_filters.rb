module LiquidFilters
  include ActionView::Helpers::NumberHelper

  def formatted_currency(price)
    number_to_currency(price)
  end

  def rounded_currency(price)
    price.round(2)
  end
end