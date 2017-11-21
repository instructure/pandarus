# This is an autogenerated file. See readme.md.
require 'pandarus/model_base'

module Pandarus
  class Outcome < ModelBase
    include Virtus.model(finalize: false)

    attribute :id, resolve_type("Integer")
    attribute :url, resolve_type("String")
    attribute :context_id, resolve_type("Integer")
    attribute :context_type, resolve_type("String")
    attribute :title, resolve_type("String")
    attribute :display_name, resolve_type("String")
    attribute :description, resolve_type("String")
    attribute :vendor_guid, resolve_type("String")
    attribute :points_possible, resolve_type("Integer")
    attribute :mastery_points, resolve_type("Integer")
    attribute :calculation_method, resolve_type("String")
    attribute :calculation_int, resolve_type("Integer")
    attribute :ratings, resolve_type("RubricRating", collection: true)
    attribute :can_edit, resolve_type(nil)
    attribute :can_unlink, resolve_type(nil)
    attribute :assessed, resolve_type(nil)
    
  end
end

