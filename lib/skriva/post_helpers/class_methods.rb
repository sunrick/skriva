module Skriva
  module PostHelpers
    module ClassMethods

      def all
        posts
      end

      def tags
        if Rails.env.production?
          @@tags ||= get_tags
        else
          get_tags
        end
      end

      def where(tags: [])
        tags = if tags.is_a? String
          tags.split(',').map(&:strip)
        elsif tags.is_a? Integer
          tags.to_s
        end
        tags = [tags].flatten.uniq.compact
        if tags.empty?
          posts
        else
          posts.select do |post|
            if post.respond_to?(:tags)
              tags.any? { |tag| post.tags =~ /#{Regexp.quote(tag)}/ }
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

        def get_tags
          posts.map do |post|
            if post.respond_to?(:tags)
              post.tags.split(',').map(&:strip)
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
