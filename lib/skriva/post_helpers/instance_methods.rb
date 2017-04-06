module Skriva
  module PostHelpers
    module InstanceMethods

      attr_reader :title, :description, :keywords, :html

      def initialize(file_name:)
        @file_name = file_name
        @markdown = Redcarpet::Markdown.new(Skriva::HTML, fenced_code_blocks: true)
        headers
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
            create_method(key, value)
          end
          hash_headers
        end
      end

      def content
        lines[content_start + 1..-1]
      end

      def html
        if @html.nil? && content.present?
          @html = @markdown.render(content.join).html_safe
        else
          @html
        end
      end

      def clear_lines
        @lines = nil
        self
      end

      private

        def create_method(key, value)
          define_singleton_method "#{key}" do
            if "#{value.first}" + "#{value.last}" == "[]"
              value.split(",").map do |element|
                element[0] = "" if element[0] == "["
                element[-1] = "" if element[-1] == "]"
                element.strip
              end
            else
              value
            end
          end
        end

        def lines
          begin
            @lines ||= File.readlines(Rails.root.join('app', 'views', 'skriva', 'posts', "#{parse_file_name}.md"))
          rescue Errno::ENOENT
            raise ActionController::RoutingError, 'Not Found'
          end
        end

        def parse_file_name
          @file_name
        end

        def separator
          "{{ skriva }}"
        end

        def content_start
          @content_start ||= begin
            start = nil
            @lines.each_with_index do |line, index|
              if line.include?(separator)
                @lines.delete_at(index)
                start = index
              end
            end
            start
          end
        end

    end
  end
end
