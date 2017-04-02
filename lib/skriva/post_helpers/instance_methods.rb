module Skriva
  module PostHelpers
    module InstanceMethods

      attr_reader :title, :description, :keywords, :html

      def initialize(slug:)
        @slug = slug
        @markdown = Redcarpet::Markdown.new(Skriva::HTML, fenced_code_blocks: true)
        setup
      end

      def headers
        @headers ||= begin
          hash_headers = {}
          headers = lines[0..content_start].select do |line|
            line.chomp.present?
          end
          headers.each do |header|
            colon = header.index(":")
            key = header[0..colon - 1].strip
            value = header[colon + 1..-1].strip
            hash_headers[key] = value
            define_singleton_method "#{key}" do
              value
            end
          end
          hash_headers
        end
      end

      def content
        lines[content_start..-1]
      end

      def html
        if @html.nil? && content.present?
          @html = @markdown.render(content.join).html_safe
        else
          @html
        end
      end

      private

        def lines
          @lines ||= File.readlines(Rails.root.join('app', 'views', 'skriva', 'posts', "#{parse_slug}.md"))
        end

        def setup
          headers
          content
        end

        def content_start
          @content_start ||= begin
            start = nil
            @lines.each_with_index do |line, index|
              if line.include?("{{ content }}")
                @lines.delete_at(index)
                start = index
              end
            end
            start
          end
        end

        def parse_slug
          @slug
        end

    end
  end
end
