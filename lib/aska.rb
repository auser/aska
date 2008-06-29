$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

Dir["aska/**"].each {|a| require a }

module Aska
  module ClassMethods
    def rules(name=:rules, str="")
      r = look_up_rules(name)
      str.each_line do |line|
        k = line[/(.+)[=\\\<\>](.*)/, 1].gsub(/\s+/, '')
        v = line[/(.+)[=\\<>](.*)/, 2].gsub(/\s+/, '')
        m = line[/[=\\<>]/, 0].gsub(/\s+/, '')
        
        create_instance_variable(k)
        r << {k => [m, v]}
      end
    end
    def create_instance_variable(name)
      return unless name
      eval("attr_accessor :#{name};@#{name} = 0.0")
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
        puts valid_rule?(rule, name)
        return valid_rule?(rule, name)
      end
      return false
    end
    def valid_rule?(rule, rules)
      return false unless rule # Can't apply a rule that is nil, can we?
      rule.each do |key,value|
        begin
          puts "#{key} - #{self.send(key)}.send(#{value[0].to_sym}, #{get_var(value[1])})"
          return self.send(key).send(value[0].to_sym, get_var(value[1]))
        rescue Exception => e
          return false
        end
      end
    end
    def get_var(name)
      attr_accessor?(name) ? name.to_sym : supported_method?(name) ? name.to_sym : name.to_f
    end
    def attr_accessor?(name)
      methods.include?("#{name}=") && methods.include?("#{name}")
    end
    def supported_method?(meth)
      %w(< = > => =<).include?("#{meth}")
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