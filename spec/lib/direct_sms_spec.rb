require 'spec_helper'
require 'net/http'

describe DirectSms do
  before(:each) do
    DirectSms.configure do |config|
      config.username = "username"
      config.password = "password"
    end
  end

  describe "balance" do
    it 'returns the remaining balance' do
      stub_request(:get, "http://api.directsms.com.au/s3/http/get_balance?password=password&username=username").
      to_return(:status => 200, :body => "credit: 300.00", :headers => {})

      sms = DirectSms::Message.new
      expect(sms.credit_balance).to eq "300.00"
    end
  end

  describe "sending sms" do
    it 'attributes can be set on new' do
      sms = DirectSms::Message.new(:type => "2-way", :max_segments => 20)

      expect(sms.max_segments).to eq 20
      expect(sms.type).to eq "2-way"
    end

    it 'sends an sms message' do
      stub_request(:get, "http://api.directsms.com.au/s3/http/send_message?max_segments=10&message=This%20is%20a%20test&password=password&to=%2B639178574111&messageid=&type=2-way&username=username").
        to_return(:status => 200, :body => "id: 1234567890", :headers => {})

      sms = DirectSms::Message.new(:type => "2-way", :max_segments => 10)
      sms.message = "This is a test"
      sms.to = "+639178574111"

      expect(sms.send_message.body).to eq "id: 1234567890"
    end
  end
end
