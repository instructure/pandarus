require "pandarus/model_base"

# This is an autogenerated file. See readme.md.
module Pandarus
  class NotificationPreference < ModelBase
    attr_accessor :href, :notification, :category, :frequency


    def self.attribute_map
      {
        :href => {:external => "href", :container => false, :type => nil},
        :notification => {:external => "notification", :container => false, :type => nil},
        :category => {:external => "category", :container => false, :type => nil},
        :frequency => {:external => "frequency", :container => false, :type => nil}

      }
    end
  end
end
