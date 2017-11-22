require 'active_support'
require 'active_support/inflector'
require 'date'

module Pandarus
  class ModelBase
    BUILTIN_TYPES = %w(
      Float
      Integer
      String
      Date
      DateTime
      Hash
    )

    def self.resolve_type(type_name, opts = {})
      qualified_type = BUILTIN_TYPES.include?(type_name) ? type_name : "Pandarus::#{type_name}"
      if ["Map", "Array", nil].include?(type_name)
        return "String"
      elsif type_name == "Object"
        return "Hash"
      elsif opts[:collection]
        return Array[qualified_type]
      else
        return qualified_type
      end
    end
  end
end
