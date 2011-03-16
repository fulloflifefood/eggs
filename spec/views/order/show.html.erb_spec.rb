require 'spec_helper'

describe "/orders/show.html.erb" do
  include OrdersHelper

  before(:each) do
    assign :order, @order = Factory(:order_with_items)
  end

  it "should show edit if logged in as admin" do
    view.stub(:current_user => Factory(:admin_user))
    assign :farm, @order.delivery.farm
    render
    rendered.should contain("Edit")
  end

  it "should show edit if logged in as member and order delivery is open" do
    user = Factory(:member_user)
    view.stub(:current_user => user)
    assign :order, @order = Factory(:order_with_items, :member => user.member, :delivery => Factory(:delivery, :status => "open"))
    assign :farm, @order.delivery.farm
    render
    rendered.should contain("Edit")
  end

  it "should not show edit if logged in as member and order delivery status is not open" do
    user = Factory(:member_user)
    view.stub(:current_user => user)
    assign :order, @order = Factory(:order_with_items, :member => user.member, :delivery => Factory(:delivery, :status => "finalized"))
    render
    rendered.should_not contain("Edit")
  end

end
