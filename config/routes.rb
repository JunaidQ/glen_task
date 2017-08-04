Rails.application.routes.draw do
  get '/index' , to: 'products#index'
  get '/shop', to: 'products#shop'

  root to: 'products#index'
end
