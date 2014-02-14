require_relative 'spec_helper'
require 'pandarus'

describe Pandarus::SisImport do
  it "initializes" do
    Pandarus::SisImport.new
  end

  context "types" do
    let(:import) {
      Pandarus::SisImport.new(
        :processing_warnings => [
          [
            "students.csv",
            "oh, it didn't work"
          ],
          [
            "students.csv",
            "oh my"
          ]
        ]
      )
    }

    it "has an array of processing_warnings" do
      import.processing_warnings.size.should == 2
      import.processing_warnings.first.size.should == 2
      import.processing_warnings[1][1].should == "oh my"
    end
  end
end