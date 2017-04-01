module Skriva
  module PostHelpers
    module ClassMethods

      def all
        @@posts ||= files.map { |file| File.basename(file).gsub('.md', '') }
      end

      private

        def files
          @@files ||= Dir[Rails.root.join('app', 'views', 'skriva', 'posts', "*.md")]
        end

    end
  end
end
