require "spec_helper"

describe FeedbackMailer do
  describe "#feedback" do
    before do
      FeedbackMailer.feedback(Feedback.new(:comment => 'comment')).deliver
      @mail = ActionMailer::Base.deliveries.last
    end

    it "renders the body" do
      @mail.body.should =~ /Comment: \ncomment/
    end
  end
end
