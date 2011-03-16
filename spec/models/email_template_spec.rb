require 'spec_helper'

describe EmailTemplate do
  describe ".create" do
    before(:each) do
      @valid_attributes = {
        :name => "Welcome Email",
        :identifier => 'new_member_welcome',
        :subject => "Welcome to Soul Food Farm",
        :from => "email@example.com",
        :bcc => "another@example.com",
        :cc => "yetanother@example.com",
        :body => "Thanks for joining us, {{user.member.first_name}}"
      }
    end

    it "should create a new instance given valid attributes" do
      EmailTemplate.create!(@valid_attributes)
    end
  end

  describe "#deliver_to" do
    before do
      Factory(:email_template, :subject => 'Hello, {{name}}').deliver_to('to@example.com', :name => 'Bob')
      @mail = ActionMailer::Base.deliveries.last
    end

    it "renders the subject" do
      @mail.subject.should == "Hello, Bob"
    end

    it "renders the body" do
      @mail.body.raw_source.should =~ /Welcome/
    end
  end
end
