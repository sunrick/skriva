module Skriva
  module PostHelpers
    module ClassMethods

      def all
        posts
      end

      def where(key:, values: [])
        values = if values.is_a? String
          values.split(',').map(&:strip)
        elsif values.is_a? Integer
          values.to_s
        end
        values = [values].flatten.uniq.compact
        if values.empty?
          posts
        else
          posts.select do |post|
            if post.respond_to?(key)
              values.any? { |value| post.send(key) =~ /#{Regexp.quote(value)}/ }
            end
          end
        end
      end

      def posts
        if Rails.env.production?
          @@posts ||= get_posts
        else
          get_posts
        end
      end

      def headers
        if Rails.env.production?
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
          if Rails.env.production?
            @@files ||= Dir[Rails.root.join('app', 'views', 'skriva', 'posts', "*.md")]
          else
            Dir[Rails.root.join('app', 'views', 'skriva', 'posts', "*.md")]
          end
        end

    end
  end
end
