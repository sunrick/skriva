module Skriva
  module PostHelpers
    module ClassMethods

      def all
        if Rails.env.production?
          @@posts ||= files.map { |file| File.basename(file).gsub('.md', '') }
        else
          files.map { |file| File.basename(file).gsub('.md', '') }
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
