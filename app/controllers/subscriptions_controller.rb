class SubscriptionsController < ApplicationController
  def index
    @product = Product.find(params[:product_id])
    @subscriptions = Subscription.find_all_by_product_id(@product.id)
    @subscriptions.sort! {|x,y| x.account.member.last_name <=> y.account.member.last_name }
  end

  def show
  end

end
