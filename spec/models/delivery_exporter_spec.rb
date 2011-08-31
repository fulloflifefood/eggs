require 'spec_helper'


describe DeliveryExporter do

  it "should only export stock items with quantity" do
    delivery = Factory(:delivery)
    delivery.stock_items << Factory.create(:stock_item, :quantity_available => 1, :product_name => 'eggs', :delivery => delivery)
    delivery.stock_items << Factory.create(:stock_item, :quantity_available => 0, :product_name => 'lettuce', :delivery => delivery)

    delivery.stock_items.size.should == 2
    delivery.stock_items.with_quantity.size.should == 1

    csv = DeliveryExporter.get_csv(delivery)
    csv.include?("eggs").should == true
    csv.include?("lettuce").should == false
  end

  describe "Separating out locations" do
    before(:each) do
      @farm = Factory(:farm_with_locations)  # SF-Potrero, Farm
      @delivery = Factory(:delivery, :farm => @farm)
      @delivery.locations << @farm.locations
      @delivery.stock_items << Factory.create(:stock_item, :quantity_available => 10, :product_name => 'eggs', :delivery => @delivery)
      @delivery.stock_items << Factory.create(:stock_item, :quantity_available => 20, :product_name => 'lettuce', :delivery => @delivery)

      @order1 = Order.new_from_delivery(@delivery)
      @order2 = Order.new_from_delivery(@delivery)
      @order1.delivery = @order2.delivery = @delivery


      @order1.member = Factory(:member)
      @order2.member = Factory(:member)
      Factory(:account, :member => @order1.member, :farm => @farm)
      Factory(:account, :member => @order2.member, :farm => @farm)

      @order1.order_items.first.quantity = 2
      @order1.order_items.last.quantity = 1

      @order2.order_items.first.quantity = 3
      @order2.order_items.last.quantity = 3

      @order1.location = @delivery.locations[0]
      @order2.location = @delivery.locations[1]

      @order1.save!
      @order2.save!

    end

    it "should not include location in headers if sorting by location" do
      headers = DeliveryExporter.get_headers(@delivery)
      headers.include?("Location").should == true

      headers_sorted = DeliveryExporter.get_headers(@delivery, true)
      headers_sorted.include?("Location").should == false
    end

    it "should return totals per-location" do
      totals = DeliveryExporter.get_totals(@delivery)
      totals[5].should == 5
      totals[6].should == 4

      totals_location1 = DeliveryExporter.get_totals(@delivery, @delivery.locations[0])
      totals_location2 = DeliveryExporter.get_totals(@delivery, @delivery.locations[1])

      # when sorting by location, no location column so index is one less
      totals_location1[4].should == 2
      totals_location1[5].should == 1
      totals_location2[4].should == 3
      totals_location2[5].should == 3
    end

    it "should not include location name in row if sorting by location" do
      order_row = DeliveryExporter.get_order_row(@order1)
      order_row.include?(@delivery.locations.first.name).should == true

      order_row_sorted = DeliveryExporter.get_order_row(@order1, true)
      order_row_sorted.include?(@delivery.locations.first.name).should == false
    end

  end
  
end