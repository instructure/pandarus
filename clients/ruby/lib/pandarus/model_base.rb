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
      Array
    )

    def self.resolve_type type_name, opts = {}
      qualified_type = BUILTIN_TYPES.include?(type_name) ? type_name : "Pandarus::#{type_name}"
      if type_name == "Map" || type_name.nil?
        return "String"
      elsif opts[:collection]
        return Array[qualified_type]
      else
        return qualified_type
      end
    end
  end
end