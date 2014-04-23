require_relative 'spec_helper'
require 'webmock/rspec'
require 'pandarus'

describe Pandarus::Client do
  let(:prefix) { "http://localhost:3000/api" }
  let(:token) { "1~eBVJyX3QYgGmRMjp5CoDkiFdpdUDyICl14e2HiRWtSzwVrAUbh36mfUXZP7pAkxS" }
  let(:client) { Pandarus::Client.new(opts) }

  context "without overridden params" do
    let(:opts) { { :prefix => prefix, :token => token } }

    it "raises when args are too few" do
      lambda { client.list_account_admins }.should raise_error
    end

    it "does not raise when args are correct" do
      stub_json_request("http://localhost:3000/api/v1/accounts/1/admins", "[]")
      lambda { client.list_account_admins(1) }.should_not raise_error
    end
  end

  context "with overridden params" do
    let(:opts) { { :account_id => 1, :prefix => prefix, :token => token } }

    it "uses overridden param account_id" do
      stub_json_request("http://localhost:3000/api/v1/accounts/1/admins", "[]")
      lambda { client.list_account_admins }.should_not raise_error
    end
  end

  def stub_json_request(url, body, method=:any)
    stub_request(method, url).
      to_return(
        :status => 200,
        :body => body,
        :headers => {
          'Content-Type' => 'application/json; charset=utf-8'
        }
    )
  end
end