require_relative 'spec_helper'
require 'pandarus'

describe Pandarus::User do
  it "initializes" do
    Pandarus::User.new
  end

  context "types" do
    let(:user) {
      Pandarus::User.new(
        :login_id => "duane",
        :last_login => "2013-12-01",
        :enrollments => [
          Pandarus::Enrollment.new(:course_id => 1),
          Pandarus::Enrollment.new(:course_id => 2)
        ]
      )
    }

    it "login_id is a string" do
      expect(user.login_id).to eq 'duane'
    end

    it "last_login is a date" do
      expect(user.last_login.year).to eq 2013
    end

    it "enrollments is array of type Enrollment" do
      expect(user.enrollments.size).to eq 2
      expect(user.enrollments.map(&:course_id)).to eq [1, 2]
    end
  end
end
