# This is an autogenerated file. See readme.md.
require 'pandarus/model_base'

module Pandarus
  class FederatedAttributesConfig < ModelBase
    include Virtus.model(finalize: false)

    attribute :admin_roles, resolve_type("String")
    attribute :display_name, resolve_type("String")
    attribute :email, resolve_type("String")
    attribute :given_name, resolve_type("String")
    attribute :integration_id, resolve_type("String")
    attribute :locale, resolve_type("String")
    attribute :name, resolve_type("String")
    attribute :sis_user_id, resolve_type("String")
    attribute :sortable_name, resolve_type("String")
    attribute :surname, resolve_type("String")
    attribute :timezone, resolve_type("String")
    
  end
end

