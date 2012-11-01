require 'rspec'
require File.dirname(__FILE__) + '/../app/countdown_timer.rb'


describe "#get_duration" do
  ct = nil

  before(:each) do
    ct = CountdownTimer.new
  end

  after(:each) do
    ct = nil
  end
  describe "given an array is passed into the method" do

    it "the first number in the passed-in array will be returned as the duration" do
      ct.get_duration([5,4,3,2]).should == 5
      ct.get_duration(["seconds",4,3,2]).should == 4
    end

    it "any duration must be > 0" do
      ct.get_duration([-1,42]).should == 42
    end

    describe "given no valid number exists in input arry" do
      it "should set duration to 0" do
        ct.get_duration(["abc", -1, "def"]).should == 0
      end
    end

  end
end

describe "#get_duration_type" do
  ct = nil

  before(:each) do
    ct = CountdownTimer.new
  end

  after(:each) do
    ct = nil
  end

  it "input string starts with 's' or 'S' then returns Seconds" do
    ct.get_duration_type("seconds").should be_a_kind_of(Seconds)

    ct.get_duration_type("skiddoo").should be_a_kind_of(Seconds)

    ct.get_duration_type("Skiddoo").should be_a_kind_of(Seconds)
  end

  it "input string starts with 'm' or 'M' then returns Minutes" do
    ct.get_duration_type("minutes").should be_a_kind_of(Minutes)
  end

  it "returns Minutes by default" do
    ct.get_duration_type("").should be_a_kind_of(Minutes)
  end
end
