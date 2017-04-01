module Skriva
  class BlogController < ApplicationController

    def index
      @files = Dir[Rails.root.join('app', 'posts', "*.md")]
      @files.map! { |file| File.basename(file).gsub('.md', '') }
    end

    def show
      @parser = Parser.new(slug: params[:slug])
    end

  end
end
