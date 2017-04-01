Skriva::Engine.routes.draw do
  get 'blog/:slug', to: 'blog#show'
  get 'blog', to: 'blog#index'
end
