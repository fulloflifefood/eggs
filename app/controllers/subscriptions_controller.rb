class SubscriptionsController < ApplicationController
  def index
    @product = Product.find(params[:product_id])
    @subscriptions = Subscription.find_all_by_product_id(@product.id)
  end

  def show
  end

end
