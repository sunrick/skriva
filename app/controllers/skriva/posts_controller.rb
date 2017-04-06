module Skriva
  class PostsController < ApplicationController

    def index
      if post_params.empty?
        @posts = Skriva::Post.all
      else
        @posts = Skriva::Post.where(post_params)
      end
    end

    def show
      @post = Skriva::Post.new(file_name: params[:slug])
    end

    private

      def post_params
        params.slice(*Post.headers)
      end

  end
end
