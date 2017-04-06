Skriva::Engine.routes.draw do
  get '/:slug', to: 'blog#show'
  get '/', to: 'blog#index'
end
