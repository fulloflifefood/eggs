require 'spec_helper'

describe AccountTransactionsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/account_transactions" }.should route_to(:controller => "account_transactions", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/account_transactions/new" }.should route_to(:controller => "account_transactions", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/account_transactions/1" }.should route_to(:controller => "account_transactions", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/account_transactions/1/edit" }.should route_to(:controller => "account_transactions", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/account_transactions" }.should route_to(:controller => "account_transactions", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/account_transactions/1" }.should route_to(:controller => "account_transactions", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/account_transactions/1" }.should route_to(:controller => "account_transactions", :action => "destroy", :id => "1")
    end
  end
end
