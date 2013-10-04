require 'active_support'

module RedPanda
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

    def assign(attr_name, value)
      props = attr(attr_name)
      if props[:type]
        if props[:container]
          value = value.map{ |v| props[:type].constantize.new(v) }
        else
          value = props[:type].constantize.new(v)
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