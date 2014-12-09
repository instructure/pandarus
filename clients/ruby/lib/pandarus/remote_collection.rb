module Pandarus
  class RemoteCollection
    include Enumerable

    def initialize(http_client, target_class, path, query_params)
      @http_client = http_client
      @target_class = target_class
      @path = path
      @query_params = query_params

      @pagination_links = []
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
      response = @http_client.get do |request|
        request.path = join_paths(base_path, @path)
        request.params = request.params.merge(@query_params) unless @query_params.empty?
      end
      handle_response(response)
    end

    def next_page
      handle_response @http_client.get(@pagination_links.last.next)
    end

    def was_last_page?
      @pagination_links.last.last_page?
    end

    def handle_response(response)
      unless @pagination_links.any? {|links| links == response.env[:pagination_links] }
        @pagination_links << response.env[:pagination_links]
      end
      response.body.map{|member| @target_class.new(member) }
    end

    private

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
