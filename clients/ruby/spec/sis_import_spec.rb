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
      expect(import.processing_warnings.size).to eq 2
      expect(import.processing_warnings.first.size).to eq 2
      expect(import.processing_warnings[1][1]).to eq "oh my"
    end
  end
end
