module Skriva
  class BlogController < ApplicationController

    def index
      if params[:tags].blank?
        @posts = Skriva::Post.all
      else
        binding.pry
        @posts = Skriva::Post.where(tags: params[:tags])
      end
    end

    def show
      @post = Skriva::Post.new(file_name: params[:slug])
    end

  end
end
