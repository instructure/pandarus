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
      expect { client.list_account_admins }.to raise_error
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
