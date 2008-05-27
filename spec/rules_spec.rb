require File.dirname(__FILE__) + '/spec_helper'

class Car
  include Aska
  attr_accessor :x, :y
  rules <<-EOR
      x > 0
      x > y
      y > 0
    EOR
end
describe "Rules" do
  before(:each) do
    @car = Car.new
  end
  it "should be able to define rules as an array and they should be set as the rules on the class" do
    @car.rules.class.should == Array
  end
  it "should be able to parse the rules lines into an array" do
    @car.rules.include?({"x"=>"x>0"}).should == true
    @car.rules.include?({"x"=>"x>y"}).should == true
    @car.rules.include?({"y"=>"y>0"}).should == true
  end
  it "should be able to apply the rules and say that they are not met when they aren't" do
    @car.x = 0
    @car.rules_valid?.should == false
  end
  it "should be able to apply the rules and say they aren't valid when they aren't all met" do
    @car.x = 5
    @car.y = 10
    @car.rules_valid?.should == false
  end
  it "should be able to apply the rules and say that they are in fact valid" do
    @car.x = 10
    @car.y = 5
    @car.rules_valid?.should == true
  end
end