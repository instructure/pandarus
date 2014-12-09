require_relative 'spec_helper'
require 'pandarus'

describe Pandarus::ModelBase do
  let(:klass) {
    Class.new(Pandarus::ModelBase) do
      include Virtus.model

      attribute :id, resolve_type("Integer")
      attribute :name, resolve_type("String")
    end
  }

  describe '#initialize' do
    it "works" do
      tm = klass.new(:id => 1, :name => "test")
      expect(tm.id).to eq 1
      expect(tm.name).to eq "test"
    end

    it 'must not raise an exception when supplied attributes not in the attribute list' do
      klass.new({foo: 'bar', id: 32})
    end
  end
end
