Skriva::Engine.routes.draw do
  get '/:slug', to: 'posts#show', as: :post
  get '/', to: 'posts#index', as: :posts
end
