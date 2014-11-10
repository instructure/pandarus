require_relative 'spec_helper'
require 'pandarus'

class TestModel < Pandarus::ModelBase
  include Virtus.model

  attribute :id, resolve_type("Integer")
  attribute :name, resolve_type("String")
end

describe Pandarus::ModelBase do
  it "initializes" do
    tm = TestModel.new(:id => 1, :name => "test")
    tm.id.should == 1
    tm.name.should == "test"
  end

  it "accepts attributes not in the map" do
    lambda do
      tm = TestModel.new(:id => 1, :integration_id => "blah")
    end.should_not raise_error
  end
end