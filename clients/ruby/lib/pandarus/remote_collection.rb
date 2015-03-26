module Pandarus
  class RemoteCollection
    include Enumerable

    def initialize(http_client, target_class, path, query_params)
      @http_client = http_client
      @target_class = target_class
      @path = path
      @query_params = query_params

      @pagination_links = []
      @next_page_cache = {}
    end

    def to_a
      each_page.entries.flatten(1)
    end

    def each
      if block_given?
        each_page do |page|
          page.each do |member|
            yield(member)
          end
        end
      else
        self.to_enum
      end
    end

    def each_page
      if block_given?
        yield first_page
        yield next_page until was_last_page?
      else
        self.to_enum
      end
    end

    def first_page
      @pagination_links = []
      @first_response ||= @http_client.get do |request|
        request.path = join_paths(base_path, @path)
        request.params = request.params.merge(@query_params) unless @query_params.empty?
      end
      handle_response(@first_response)
    end

    def next_page
      key = @pagination_links.last.next
      @next_page_cache[key] ||= @http_client.get(key)
      handle_response @next_page_cache[key]
    end

    private

    def was_last_page?
      return true if @pagination_links == []
      @pagination_links.last.last_page?
    end

    def handle_response(response)
      response_links = response.env[:pagination_links]
      if response_links && !@pagination_links.any? {|existing_links| existing_links == response_links }
        @pagination_links << response.env[:pagination_links]
      end
      response.body.map{|member| @target_class.new(member) }
    end

    def base_path
      @http_client.url_prefix.path
    end

    def join_paths(base, additional)
      base.gsub!(/\/+\z/, '') # remove trailing slashes
      additional.gsub!(/\A\/+/, '') # remove leading slashes
      [base, additional].join('/')
    end
  end
end
