$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

Dir["aska/**"].each {|a| require a }

module Aska
  module ClassMethods
    def rules(name=:rules, str="")
      r = look_up_rules(name)
      str.each_line do |line|
        k = line[/(.+)[=\\\<\>](.*)/, 1].gsub(/\s+/, '')
        v = line[/(.+)[=\\<>](.*)/, 0].gsub(/\s+/, '')
        r << {k => v}
      end
    end
    def look_up_rules(name)
      defined_rules["#{name}"] ||= []
    end
    def defined_rules
      @defined_rules ||= {}
    end
  end
  
  module InstanceMethods
    def rules
      @rules ||= self.class.defined_rules
    end
    def valid_rules?(name=:rules)
      self.class.look_up_rules(name).each do |rule|
        return false unless valid_rule?(rule, name)
      end
      return true
    end
    def valid_rule?(rule, rules)
      return false unless rule # Can't apply a rule that is nil, can we?
      rule.each do |key,value|
        begin
          return eval(value)
        rescue Exception => e
          return false
        end
      end
    end
    def method_missing(m, *args)
      if self.class.defined_rules.has_key?("#{m}")
        self.class.send(:define_method, m) do
          self.class.look_up_rules(m)
        end
        self.send m
      else
        super
      end
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end