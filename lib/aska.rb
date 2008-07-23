=begin rdoc
  Aska
=end
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
      unless attr_accessors.include?(":#{name}")
        attr_accessors << name.to_sym
        eval "attr_accessor :#{aska_named(name)}"
      end
    end
    def look_up_rules(name)
      defined_rules["#{name}"] ||= []
    end
    def are_rules?(name)
      !look_up_rules(name).empty?
    end
    def attr_accessors
      @attr_accessors ||= []
    end
    def defined_rules
      @defined_rules ||= {}
    end
    def aska_named(name)
      "#{name}_aska"
    end
  end
  
  module InstanceMethods
    def rules
      @rules ||= self.class.defined_rules
    end
    def valid_rules?(name=:rules)
      arr = self.class.look_up_rules(name).collect do |rule|
        valid_rule?(rule)
      end
      arr.reject {|a| a == true }.empty?
    end
    def aska(m)
      if respond_to?(m.to_sym)
        self.send(m.to_sym)
      else
        self.send(aska_named(m.to_sym))
      end
    end
    def valid_rule?(rule)
      return false unless rule # Can't apply a rule that is nil, can we?
      rule.each do |key,value|
        begin
          # puts "testing if #{key} (#{self.send(key)}) is #{value[0]} #{get_var(value[1])} [#{value[1]}]"
          return aska(key).send(value[0].to_sym, get_var(value[1]))
        rescue Exception => e
          return false
        end
      end
    end
    # Get the variable from the class
    # If it's defined as an attr_accessor, we know it has been defined as a rule
    # Otherwise, if we are passing it as a 
    def get_var(name)
      attr_accessor?(name) ? aska(name) : (supported_method?(name) ? name.to_sym : name.to_f)
    end
    def aska_named(name)
      self.class.aska_named(name)
    end
    def attr_accessor?(name)
      self.class.attr_accessors.include?(name.to_sym)
    end
    def supported_method?(meth)
      %w(< > == => =<).include?("#{meth}")
    end
    
    def look_up_rules(r);self.class.look_up_rules(r);end
    def are_rules?(r);self.class.are_rules?(r);end
    
    def method_missing(m, *args)      
      if self.class.defined_rules.has_key?("#{m}")
        self.class.send(:define_method, m) do
          self.class.look_up_rules(m)
        end
        self.send m
      elsif self.class.attr_accessors.include?(m.to_sym)
        self.class.send :define_method, aska_named(m).to_sym do
          # self.send(aska_named(m).to_sym)
        end
        self.send(aska_named(m).to_sym)
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