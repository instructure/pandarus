require_relative 'spec_helper'
require 'pandarus'

class TestModel < Pandarus::ModelBase
    attr_accessor :id, :name
    def self.attribute_map
      {
        :id => {:external => "id", :container => false, :type => "Integer"},
        :name => {:external => "name", :container => false, :type => "String"}
      }
    end
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