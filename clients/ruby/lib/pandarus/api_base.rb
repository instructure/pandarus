require "uri"
require "footrest"
require "pandarus/remote_collection"

module Pandarus
  class APIBase < Footrest::Client
    attr_reader :response

    def initialize(*args)
      @pagination_params = {}
      super
    end

    # Swagger allows for each param to be a query param or a form param, which
    # is a bit unusual because in the 99% case, all params will be of one type
    # or the other for a single Canvas request. In order to accommodate the 1%
    # case, however, we allow for mixed requests in general.
    def mixed_request(method, path, query_params, form_params, headers)
      @response = connection.send(method) do |r|
        if query_params.empty?
          r.path = fullpath(path)
        else
          r.url(fullpath(path), query_params)
        end
        r.body = form_params unless form_params.empty?
        r.headers = headers if headers
      end
      @response.body
    end

    def remember_key(method, path)
      "#{method}:#{path}"
    end

    def parse_page_params!(url)
      return nil if url.nil?
      uri = URI.parse url
      Hash[URI.decode_www_form(uri.query)]
    rescue URI::InvalidURIError
      nil
    end

    def page_params_store(method, path, response=@response.env)
      @pagination_params[remember_key(method, path)] = {
        next: parse_page_params!(response[:next_page]),
        current: parse_page_params!(response[:current_page]),
        last: parse_page_params!(response[:last_page])
      }
    end

    def page_params_load(method, path)
      @pagination_params[remember_key(method, path)]
    end

    def was_last_page?(method, path)
      params = @pagination_params[remember_key(method, path)]
      return false if params.nil? || params[:current].nil? || params[:last].nil?
      return (params[:current] == params[:last])
    end

    def underscored_merge_opts(opts, base)
      base.merge(opts).merge(underscored_flatten_hash(opts))
    end

  protected

    # Take a hash such as { :user => { :name => "me" } } and return a flattened
    # hash such as { :user__name__ => "me" }. We do this as a workaround to
    # swagger's disdain for rails-style square bracket parameters in the url.
    def underscored_flatten_hash(hash)
      Hash[
        dot_flatten_hash(hash).map do |key, value|
          count = 0
          newkey = key.to_s.gsub(".") {|x| count += 1; count == 1 ? '__' : '____' }
          newkey += '__' if count > 0
          [newkey.to_sym, value]
        end
      ]
    end

    def dot_flatten_hash(hash)
      Hash[dot_flatten_recur(hash)]
    end

    def dot_flatten_recur(hash)
      hash.map do |k1, v1|
        if v1.is_a?(Hash)
          dot_flatten_recur(v1).map do |k2, v2|
            ["#{k1}.#{k2}", v2]
          end.flatten(1)
        else
          [k1, v1]
        end
      end
    end

    def escape_string(string)
      URI.encode(string.to_s)
    end

    # Convert something like user__name__ to user[name]
    def underscores_to_square_brackets(key)
      key.to_s.gsub(/__(.+?)__/) do |x|
        "[#{ $1 }]"
      end.to_sym
    end

    def select_query_params(params, param_keys)
      param_keys << :per_page
      select_params(params, param_keys)
    end

    # pull querystring keys from options, and convert double underscores
    # back to square brackets
    def select_params(params, param_keys)
      Hash[
        params.select do |key, value|
          param_keys.include? key
        end.map do |key, value|
          [underscores_to_square_brackets(key), value]
        end
      ]
    end

    def path_replace(path, args={})
      rpath = path.dup
      args.each_pair do |key, value|
        rpath.sub!("{#{key}}", escape_string(value))
      end
      rpath
    end
  end
end
