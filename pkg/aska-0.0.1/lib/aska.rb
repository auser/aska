$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

Dir["aska/**"].each {|a| require a }

module Aska
  module ClassMethods
    def rules(str="")
      str.split(/[\n]+/).each do |line|
        line = line.chomp
        k = line[/(.+)[=\\\<\>](.*)/, 1].gsub(/\s+/, '')
        v = line[/(.+)[=\\<>](.*)/, 0].gsub(/\s+/, '')
        h = {k => v}
        defined_rules << h
      end
    end
    def defined_rules
      @defined_rules ||= []
    end
  end
  
  module InstanceMethods
    def rules
      @rules ||= self.class.defined_rules
    end
    def rules_valid?
      rules.each do |rule|
        return false unless rule_valid?(rule)
      end
      return true
    end
    def rule_valid?(rule)
      return false unless rule # Can't apply a rule that is nil, can we?
      rule.each do |key,value|
        begin
          return eval(value)
        rescue Exception => e
          return false
        end
      end
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end