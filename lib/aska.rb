$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

Dir["**/aska/**"].each {|a| require a }

module Aska
end