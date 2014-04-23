require 'pandarus/v1_api'
require 'active_support'

module Pandarus
  # Client is a class just like Pandarus::V1, but you only need to pass
  # the account_id in once.
  #
  # Example:
  #   client = Pandarus::Client.new(
  #              :account_id => 1,
  #              :prefix => "http://canvas.instructure.com/api",
  #              :token  => "1~z8d91308...etc")
  #
  # Now, instead of passing in account_id to each method, just skip it:
  #   client.list_available_reports
  class Client
    # Let's act like a Proxy: remove all of our own methods
    instance_methods.each { |m| undef_method m unless m =~ /(^__|^send$|^object_id$)/ }

    def initialize(opts={}, target=nil)
      footrest_keys = [:token, :prefix, :logging, :logger]
      @footrest_opts = opts.slice(*footrest_keys)
      # Prepare defaults
      @overridden_params = opts
      @overridden_params.delete_if{ |k,v| footrest_keys.include?(k.to_sym) }

      @target = target
    end

  protected
    def method_missing(name, *args, &block)
      params = target.method(name).parameters
      if params.empty?
        # no params, nothing to modify, just pass the block
        target.send(name, *args, &block)
      else
        # Fill in any args that are overridden, and use the others as-is
        overridden_args = required_params(params).map do |param_name|
          if @overridden_params.keys.include?(param_name)
            @overridden_params[param_name]
          else
            args.shift
          end
        end

        # Tack on optional args, if any
        overridden_args += args if args.size > 0

        # Send our method + args to the Pandarus::V1 target of this proxy object
        target.send(name, *overridden_args, &block)
      end
    end

    def required_params(params)
      params.select{ |p| p.first == :req }.map{ |p| p.last }
    end

    def target
      @target ||= Pandarus::V1.new(@footrest_opts)
    end
  end

end