require_relative 'spec_helper'
require 'pandarus'

describe Pandarus::APIBase do
  context "underscores_to_square_brackets" do
    def u2sb(string)
      base.send(:underscores_to_square_brackets, string)
    end

    let(:base) { Pandarus::APIBase.new }

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
end