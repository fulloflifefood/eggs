require "spec_helper"

describe Notifier do
  describe "#order_confirmation" do
    before do
      Notifier.order_confirmation(Factory(:order)).deliver
      @mail = ActionMailer::Base.deliveries.last
    end

    it "renders the body" do
      @mail.body.should =~ /Location: SF \/ Potrero/
    end
  end

end
