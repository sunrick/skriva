module Skriva
  class Parser

    attr_reader :title, :description, :keywords, :html

    def initialize(slug:)
      @slug = slug
      markdown = Redcarpet::Markdown.new(HTML, fenced_code_blocks: true)
      lines = File.readlines(Skriva::Engine.root.join('app', 'views', 'skriva', 'posts', "#{parse_slug}.md"))
      @title = lines.first.try(:chomp)
      @description = lines.second.try(:chomp)
      @keywords = lines.third.try(:chomp)
      @content = lines[3..-1].try(:join)
      binding.pry
      if @content
        @html = markdown.render(@content).html_safe
      end
    end

    private

      def parse_slug
        @slug
      end

  end
end
