Rails.application.routes.draw do
  get "stw/index"
  get '/stw', to: 'stw#index'

  resources :posts


end
