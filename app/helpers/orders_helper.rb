module OrdersHelper
  def item_available?(order_item, member)
    return true if current_user.has_role?(:admin)

    product = order_item.stock_item.product
    is_subscribable = product.subscribable
    account = member.account_for_farm(@farm)

    subscription_visibility = is_subscribable ? account.has_subscription?(product) : true
    quantity_visibility = order_item.stock_item.quantity_available > 0 || order_item.quantity != 0

    subscription_visibility && quantity_visibility

  end
end
