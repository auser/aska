require File.dirname(__FILE__) + '/spec_helper'

class Car
  include Aska
  rules :names, <<-EOR
      x > 0      
      y > 0
      x > y
    EOR
end
describe "Rules" do
  before(:each) do
    @car = Car.new
  end
  it "should be able to define rules as an array and they should be set as the rules on the class" do
    @car.rules.class.should == Hash
  end
  it "should be able to look up the rules based on the name into an array" do
    @car.names.class.should == Array
  end
  describe "parsing" do
    it "should be able to parse the x > 0 into an array" do
      @car.names.include?({"x"=>[">","0"]}).should == true
    end
    it "should be able to parse y > 0 into an array" do
      @car.names.include?({"y"=>[">","0"]}).should == true
    end
    it "should be able to parse x > y into the hash" do
      @car.names.include?({"x"=>[">","y"]}).should == true
    end
    it "should have 3 rules" do
      @car.names.size.should == 3
    end
    it "should be able to look up the names as a rule" do
      Car.look_up_rules(:names).should == [{"x"=>[">", "0"]}, {"y"=>[">", "0"]}, {"x"=>[">", "y"]}]
    end
  end
  it "should be able to get a number with the instance and return it as a float" do
    @car.get_var(4).class.should == Float
  end
  it "should be able to get the method it's applying as a method symbol" do
    @car.get_var(:<).class.should == Symbol
  end
  it "should be able to retrieve the value of the rule when checking if it's valid" do
    @car.x = 10
    @car.valid_rule?({:x => [:==, 10]}).should == true
  end
  it "should be able to apply the rules and say that they are not met when they aren't" do
    @car.valid_rules?(:names).should == false
  end
  it "should be able to apply the rules and say they aren't valid when they aren't all met" do
    @car.x = 5
    @car.y = 10
    # puts (@car.x > 0) && (@car.y > 0) && (@car.x > @car.y)
    @car.valid_rules?(:names).should == false
  end
  it "should be able to apply the rules and say they aren't valid when they aren't all met" do
    @car.x = 5
    @car.y = 0
    @car.valid_rules?(:names).should == false
  end
  it "should be able to apply the rules and say that they are in fact valid" do
    @car.x = 10
    @car.y = 5    
    @car.valid_rules?(:names).should == true
  end
end