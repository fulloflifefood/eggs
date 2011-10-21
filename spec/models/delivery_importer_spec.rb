require 'spec_helper'


describe DeliveryImporter do
  before(:each) do
    @imported_data = FasterCSV.read("spec/csmc_import.csv")
    @importer = DeliveryImporter.new
  end

  it "creates a static stock item from an array" do
    line = @imported_data[4]
    stock_item = @importer.get_stock_item(line)
    stock_item.class.should == StockItem
    stock_item.product_category.should == "bread"
    stock_item.product_name.should == "bread: Sesame Wheat Levain Loaf"
    stock_item.quantity_available.should == 10
    stock_item.max_quantity_per_member.should == 3
    stock_item.product_estimated.should == false
    stock_item.product_price.should == 5.5
    stock_item.product_price_code.should == "$5.50"
  end

  it "creates an estimated stock item from an array" do
    line = @imported_data[28]
    stock_item = @importer.get_stock_item(line)

    stock_item.product_estimated.should == true
    stock_item.product_price.should == 19
    stock_item.product_price_code.should == "$9.75/lb, 1.5-2lb"

  end

  it "doesn't create a stock item if no quantity" do
    line = @imported_data[17]
    @importer.get_stock_item(line).should == nil
  end

end