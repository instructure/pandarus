require 'active_support'
require 'active_support/inflector'
require 'date'
 
module Pandarus
  class ModelBase
    def initialize(attributes = {})
      return if attributes.empty?
      attributes.each_pair do |name, value|
        if has_attr? name.to_sym
          assign(name, value)
        else
          raise ArgumentError, "#{name} is not an attribute of #{self.class}"
        end
      end
    end
 
    def attr(name)
      self.class.attribute_map[name.to_sym]
    end
 
    def has_attr?(name)
      self.class.attribute_map.has_key? name.to_sym
    end
 
    def inspect
      Hash[
        self.class.attribute_map.keys.map do |key|
          [key, instance_variable_get("@#{key}")]
        end
      ].inspect.sub(/^\{/,"<#{self.class} ").sub(/\}$/,'>')
    end

    def vivify(constant_name, value)
      klass = begin
        # Try Ruby built-in constants first
        constant_name.constantize
      rescue NameError
        # Pandarus models second
        "Pandarus::#{constant_name}".constantize
      end
      begin
        # Check if the constant is a method, e.g. Integer(), Float()
        send(constant_name, value)
      rescue NoMethodError
        # Otherwise, it's probably a class
        if klass.respond_to?(:parse)
          # Some classes convert strings with "parse", e.g. DateTime
          klass.parse(value)
        else
          # Most classes just need to be passed the value
          klass.new(value)
        end
      end
    end
 
    def assign(attr_name, value)
      props = attr(attr_name)
      if props[:type]
        if props[:container]
          value = value.map{ |v| vivify(props[:type], v) }
        elsif !value.nil?
          value = vivify(props[:type], value)
        end
      end
      instance_variable_set("@#{attr_name}", value)
    end
 
    def to_body
      body = {}
      self.class.attribute_map.each_pair do |key, props|
        unless (value = self.send(key).nil?)
          body[props[:external]] = value
        end
      end
      body
    end
  end
end