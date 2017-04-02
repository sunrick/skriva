module Skriva
  module PostHelpers
    module ClassMethods

      def all
        posts
      end

      def tags
        values_for(key: :tags)
      end

      def values_for(key:)
        if Rails.env.production?
          @@values_for ||= get_values_for(key: key)
        else
          get_values_for(key: key)
        end
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

      private

        def get_values_for(key:)
          posts.map do |post|
            if post.respond_to?(key)
              post.send(key).split(',').map(&:strip)
            end
          end.flatten.uniq.sort
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
