module Skriva
  class BlogController < ApplicationController

    def index
      @posts = Skriva::Post.all
    end

    def show
      @post = Skriva::Post.new(slug: params[:slug])
    end

  end
end
