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
          {
            :course_id => 1
          },
          {
            :course_id => 2
          }
        ]
      )
    }

    it "login_id is a string" do
      user.login_id.should == "duane"
    end

    it "last_login is a date" do
      user.last_login.year.should == 2013
    end

    it "enrollments is array of type Enrollment" do
      user.enrollments.size.should == 2
      user.enrollments.map{ |e| e.course_id }.should == [1, 2]
    end
  end
end