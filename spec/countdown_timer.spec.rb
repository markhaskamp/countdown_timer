require 'rspec'
require File.dirname(__FILE__) + '/../app/CountdownTimer.rb'


describe "#flatten_input_args" do
  it "'3 m' returns [3,m]" do
    ct = CountdownTimer.new
    ct.flatten_input_array('3 m').should == ["3", 'm']
  end

  it "['3', m'] returns [3,m]" do
    ct = CountdownTimer.new
    ct.flatten_input_array(['3', 'm']).should == ["3", 'm']
  end

  it "['3 m'] returns [3,m]" do
    ct = CountdownTimer.new
    ct.flatten_input_array(['3 m']).should == ["3", 'm']
  end
end

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
    ct.get_duration_type(["seconds"]).should be_a_kind_of(Seconds)
    ct.get_duration_type([42,"seconds"]).should be_a_kind_of(Seconds)
    ct.get_duration_type(["skiddoo"]).should be_a_kind_of(Seconds)
    ct.get_duration_type(["Skiddoo"]).should be_a_kind_of(Seconds)
  end

  it "input string starts with 'm' or 'M' then returns Minutes" do
    ct.get_duration_type(["minutes"]).should be_a_kind_of(Minutes)
  end

  it "input string starts contains a '[digit]:[digit]' then returns Composite" do
    ct.get_duration_type(["1:30"]).should be_a_kind_of(Composite)

    ct.get_duration_type(["x:30"]).should be_a_kind_of(Unknown)
  end

  it "returns Uknown by default" do
    ct.get_duration_type(["z"]).should be_a_kind_of(Unknown)
  end
end

describe Seconds do
  describe "#continue_countdown?" do
    sec = Seconds.new

    it "returns true when elapsed_time < duration" do
      sec.continue_countdown?(15, 10).should be_true
    end
    it "returns false when elapsed_time = duration" do
      sec.continue_countdown?(15, 15).should be_false
    end
    it "returns false when elapsed_time > duration" do
      sec.continue_countdown?(15, 17).should be_false
    end
  end

  describe "#describe_duration" do
    sec = Seconds.new
    it "when seconds are more than 1 then returns 'n seconds'" do
      sec.describe_duration(2).should == "2 seconds" 
    end
    it "when seconds are equal to 1 then returns '1 second'" do
      sec.describe_duration(1).should == "1 second" 
    end
    it "when seconds are equal to 0 then returns '0 seconds'" do
      sec.describe_duration(0).should == "0 seconds" 
    end
  end
end

describe Minutes do
  describe "#continue_countdown?" do
    sec = Minutes.new

    it "returns true when elapsed_time < duration" do
      sec.continue_countdown?(5, 299).should be_true
    end
    it "returns false when elapsed_time = duration" do
      sec.continue_countdown?(5, 300).should be_false
    end
    it "returns false when elapsed_time > duration" do
      sec.continue_countdown?(5, 400).should be_false
    end
  end

  describe "#describe_duration" do
    min = Minutes.new
    it "when minutes are more than 1 then returns 'n minutes'" do
      min.describe_duration(2).should == "2 minutes" 
    end
    it "when minutes are equal to 1 then returns '1 minute'" do
      min.describe_duration(1).should == "1 minute" 
    end
    it "when minutes are equal to 0 then returns '0 minutes'" do
      min.describe_duration(0).should == "0 minutes" 
    end
  end
end

describe Composite do
  describe "#continue_countdown?" do
    comp = Composite.new

    it "returns true when elapsed_time < duration" do
      comp.continue_countdown?("1:30", 60).should be_true
    end
    it "returns false when elapsed_time = duration" do
      comp.continue_countdown?("0:30", 30).should be_false
    end
    it "returns false when elapsed_time > duration" do
      comp.continue_countdown?("2:30", 400).should be_false
    end
  end

  describe "#describe_duration" do
    comp = Composite.new
    it "returns time description" do
      comp.describe_duration('0:30').should == '0:30'
    end
  end
end

describe Unknown do
  describe "#continue_countdown?" do
    unk = Unknown.new

    it "returns false" do
      unk.continue_countdown?(15, 10).should be_false
    end
  end

  describe "#describe_duration" do
    unk = Unknown.new
    it "displays don't understand -input args-" do
      unk.describe_duration("foo").should == "Don't understand 'foo'"
    end
  end
end
