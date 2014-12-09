require_relative 'spec_helper'
require 'pandarus'

describe Pandarus::APIBase do
  let(:base) { Pandarus::APIBase.new }

  context "underscores_to_square_brackets" do
    def u2sb(string)
      base.send(:underscores_to_square_brackets, string)
    end

    it "converts surrounding double underscores" do
      expect(u2sb("prefix__inside__")).to eq :"prefix[inside]"
    end

    it "ignores single underscores" do
      expect(u2sb("prefix__inner_word__")).to eq :"prefix[inner_word]"
    end

    it "converts multiple double underscores" do
      expect(u2sb("prefix__alpha____beta_gamma__")).to eq :"prefix[alpha][beta_gamma]"
    end
  end

  context "dot_flatten_hash" do
    it "turns a hash into dot notation" do
      sample = { :user => { :name => "me" } }
      result = base.send(:dot_flatten_hash, sample)
      expect( result ).to eq({"user.name" => "me"})
    end

    it "turns a hash with array values into a hash" do
      sample = { :user => { :ids => [1, 2, 3] }, :z => { :ids => [:a, :b] } }
      result = base.send(:dot_flatten_hash, sample)
      expect( result ).to eq({"user.ids" => [1, 2, 3], "z.ids" => [:a, :b]})
    end
  end

  context "parse_page_params" do
    it "returns nil when passed nil" do
      expect(base.parse_page_params!(nil)).to be_nil
    end

    it "returns nil when an invalid url is passed" do
      expect(base.parse_page_params!("malformed url stuff right here")).to be_nil
    end

    it "returns hashed page parameters when a valid url is passed" do
      parsed_value = base.parse_page_params!("some_url?page=pageX&per_page=SOMENUMBER")
      expect(parsed_value).to eq( {"page"=>"pageX", "per_page"=>"SOMENUMBER"})
    end
  end

  context "page_params_store" do
    it "stores current, next, and last page values from urls" do
      urls = {
        next_page: "some_url?page=next_page&per_page=SOMENUMBER",
        current_page: "some_url?page=current_page&per_page=SOMENUMBER",
        last_page: "some_url?page=last_page&per_page=SOMENUMBER"
      }
      base.page_params_store(:some_method, 'a_path', urls)
      expect(base.page_params_load(:some_method, 'a_path')).to eq({:next=>{"page"=>"next_page", "per_page"=>"SOMENUMBER"}, :current=>{"page"=>"current_page", "per_page"=>"SOMENUMBER"}, :last=>{"page"=>"last_page", "per_page"=>"SOMENUMBER"}})
    end
  end

  context "was_last_page?" do
    it "returns true when current and last page are the same" do
      urls = {
        current_page: "some_url?page=pageB&per_page=SOMENUMBER",
        last_page: "some_url?page=pageB&per_page=SOMENUMBER"
      }
      base.page_params_store(:some_method, 'a_path', urls)
      expect(base.was_last_page?(:some_method, 'a_path')).to be_truthy
    end

    it "returns false when current and last page are different" do
      urls = {
        current_page: "some_url?page=pageA&per_page=SOMENUMBER",
        last_page: "some_url?page=pageB&per_page=SOMENUMBER"
      }
      base.page_params_store(:some_method, 'a_path', urls)
      expect(base.was_last_page?(:some_method, 'a_path')).to be_falsey
    end

    it "returns false when current and last page are nil" do
      urls = {
        current_page: nil,
        last_page: nil
      }
      base.page_params_store(:some_method, 'a_path', urls)
      expect(base.was_last_page?(:some_method, 'a_path')).to be_falsey
    end

  end
end
