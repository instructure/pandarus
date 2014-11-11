require_relative 'spec_helper'
require 'pandarus'

describe Pandarus::APIBase do
  let(:base) { Pandarus::APIBase.new }

  context "underscores_to_square_brackets" do
    def u2sb(string)
      base.send(:underscores_to_square_brackets, string)
    end

    it "converts surrounding double underscores" do
      u2sb("prefix__inside__").should == :"prefix[inside]"
    end

    it "ignores single underscores" do
      u2sb("prefix__inner_word__").should == :"prefix[inner_word]"
    end

    it "converts multiple double underscores" do
      u2sb("prefix__alpha____beta_gamma__").should ==
        :"prefix[alpha][beta_gamma]"
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
end