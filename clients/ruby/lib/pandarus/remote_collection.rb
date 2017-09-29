module Pandarus
  class RemoteCollection
    include Enumerable

    def initialize(http_client, target_class, path, query_params)
      @http_client = http_client
      @target_class = target_class
      @path = path
      @cache_pages = query_params[:cache_pages].nil? ? true : query_params[:cache_pages]
      @query_params = query_params.except(:cache_pages)

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
      response = @first_response || @http_client.get do |request|
        request.path = join_paths(base_path, @path)
        request.params = request.params.merge(@query_params) unless @query_params.empty?
      end
      @first_response ||= response if @cache_pages
      handle_response(response)
    end

    def next_page
      key = @pagination_links.last.next
      # cache_pages defaults to true, but for massive remote collections
      # keeping everything cached will eventually eat all the available memory
      if @cache_pages
        @next_page_cache[key] ||= @http_client.get(key)
        handle_response @next_page_cache[key]
      else
        handle_response @http_client.get(key)
      end
    end

    private

    def was_last_page?
      return true if @pagination_links == []
      @pagination_links.last.last_page?
    end

    def handle_response(response)
      response_links = response.env[:pagination_links]
      if response_links && !@pagination_links.any? {|existing_links| existing_links == response_links }
        update_pagination_links(response.env[:pagination_links])
      end
      response.body.map{|member| @target_class.new(member) }
    end

    def update_pagination_links(response_pages)
      if @cache_pages
        @pagination_links << response_pages
      else
        @pagination_links = [response_pages]
      end
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
