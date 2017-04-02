module Skriva
  module PostHelpers
    module ClassMethods

      def all
        if Rails.env.production?
          @@posts ||= files.map do |file|
            file_name = File.basename(file).gsub('.md', '')
            post = Post.new(lines: file_name)
            post.clear_lines
          end
        else
          @@posts = files.map do |file|
            file_name = File.basename(file).gsub('.md', '')
            post = Post.new(file_name: file_name)
            post.clear_lines
          end
        end
      end

      def where(tags: [])
        all
        tags = if tags.is_a? String
          tags.split(',').map(&:strip)
        elsif tags.is_a? Integer
          tags.to_s
        end
        tags = [tags].flatten.uniq.compact
        if tags.empty?
          @@posts
        else
          @@posts.select do |post|
            if post.respond_to?(:tags)
              tags.any? { |tag| post.tags =~ /#{Regexp.quote(tag)}/ }
            end
          end
        end
      end

      private

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
