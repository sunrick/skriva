module Skriva
  module PostHelpers
    module ClassMethods

      def all
        posts
      end

      def where(options)
        filtered_posts = posts
        options.each do |key, values|
          values = if values.is_a? String
            values.split(',').map(&:strip)
          elsif values.is_a? Integer
            values.to_s
          end
          values = [values].flatten.uniq.compact
          next if values.empty?
          filtered_posts = filtered_posts.select do |post|
            next if !post.respond_to?(key)
            values.any? do |value|
              post_value = post.send(key)
              if post_value.is_a? Array
                value.in? post_value
              else
                post_value =~ /\A#{Regexp.quote(value)}\z/
              end
            end
          end
        end
        filtered_posts
      end

      def posts
        if cache_posts?
          @@posts ||= get_posts
        else
          get_posts
        end
      end

      def headers
        if cache_posts?
          @@headers ||= get_headers
        else
          get_headers
        end
      end

      def method_missing(method_name, *arguments, &block)
        if method_name.to_s.include?("breakdown")
          name = headers.detect { |header| header.pluralize == method_name.to_s.gsub("_breakdown", "") }
          if name
            get_breakdown_for(key: name)
          else
            super
          end
        else
          name = headers.detect { |header| header.pluralize == method_name.to_s }
          if name
            get_values_for(key: name)
          else
            super
          end
        end
      end

      private

        def cache_posts?
          Rails.env.production?
        end

        def get_headers
          posts.map do |post|
            headers = post.headers.keys
            post.clear_lines
            headers
          end.flatten.uniq.compact
        end

        def get_values_for(key:)
          values = posts.map do |post|
            if post.respond_to?(key)
              post.send(key)
            end
          end.flatten.sort
        end

        def get_breakdown_for(key:)
          hash = Hash.new(0) # default keys to 0
          values = get_values_for(key: key)
          values.each { |v| hash[v] += 1 }
          hash
        end

        def get_posts
          files.map do |file|
            file_name = File.basename(file).gsub('.md', '')
            post = Post.new(file_name: file_name)
            post.clear_lines
          end
        end

        def files
          if cache_posts?
            @@files ||= Dir[Rails.root.join('app', 'views', 'skriva', 'posts', "*.md")]
          else
            Dir[Rails.root.join('app', 'views', 'skriva', 'posts', "*.md")]
          end
        end

    end
  end
end
