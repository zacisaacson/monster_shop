Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'items#index'

  # resources :merchants do
  #   resources :items, only: [:index, :new, :create]
  # end

  get '/merchants', to: 'merchants#index'
  post '/merchants', to: 'merchants#create'
  get '/merchants/new', to: 'merchants#new'

  get '/merchants/:id', to: 'merchants#show'
  get '/merchants/:id/edit', to: 'merchants#edit'
  patch '/merchants/:id', to: 'merchants#update'
  delete '/merchants/:id', to: 'merchants#destroy'

  get '/merchants/:merchant_id/items', to: 'items#index'
  post '/merchants/:merchant_id/items', to: 'items#create'
  get '/merchants/:merchant_id/items/new', to: 'items#new'


  # resources :items, except: [:new, :create] do
  #   resources :reviews, only: [:new, :create]
  # end

  get '/items', to: 'items#index'
  get '/items/:id/edit', to: 'items#edit'
  get '/items/:id', to: 'items#show'
  patch '/items/:id', to: 'items#update'
  delete '/items/:id', to: 'items#destroy'

  post '/items/:item_id/reviews', to: 'reviews#create'
  get '/items/:item_id/reviews/new', to: 'reviews#new'

  # resources :reviews, only: [:edit, :update, :destroy]

  get '/reviews/:id/edit', to: 'reviews#edit'
  patch '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy'

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'
  patch '/cart/:item_id/:increment_decrement', to: 'cart#increment_decrement'

  get '/profile/orders', to: 'user_orders#index'
  get '/profile/orders/:id', to: 'user_orders#show'
  get '/profile/orders/:address_id/new', to: 'user_orders#new'
  post '/profile/orders/:address_id', to: 'user_orders#create'
  get '/profile/orders/:id/edit', to: 'user_orders#edit'
  patch '/profile/orders/:id/addresses/:address_id', to: 'user_orders#update'
  patch '/profile/orders/:id', to: 'user_orders#cancel'


  get '/profile', to: 'users#show'
  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/profile/edit', to: 'users#edit'
  patch '/profile', to: 'users#update'


  get '/profile/addresses', to: 'addresses#index'
  get '/profile/addresses/:id/edit', to: 'addresses#edit'
  patch '/profile/addresses/:id', to: 'addresses#update'
  get '/profile/addresses/new', to: 'addresses#new'
  post '/profile/addresses', to: 'addresses#create'
  delete '/profile/addresses/:id', to: 'addresses#destroy'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  namespace :merchant do
    # resources :items, except: [:show]

    get '/items', to: 'items#index'
    post '/items', to: 'items#create'
    get '/items/new', to: 'items#new'
    get '/items/:id/edit', to: 'items#edit'
    patch '/items/:id', to: 'items#update'
    delete '/items/:id', to: 'items#destroy'


    root 'dashboard#index'

    get '/orders/:id', to: 'orders#show'
    patch '/orders/:order_id/item_orders/:item_order_id', to: 'orders#update'
  end

  namespace :admin do
    # resources :users, only: [:index, :show]

    get '/users', to: 'users#index'
    get '/users/:id', to: 'users#show'

    root 'dashboard#index'

    get '/users/:id/orders', to: 'user_orders#index'
    get '/users/:user_id/orders/:order_id', to: 'user_orders#show'
    patch '/users/:user_id/orders/:order_id', to: 'user_orders#update'

    get '/merchants/:id', to: 'dashboard#merchant_index'
    patch '/merchants/:id', to: 'merchants#update'
    get '/merchants/:merchant_id/orders/:order_id', to: 'merchant_orders#show'
    patch '/merchants/:merchant_id/orders/:order_id/item_orders/:item_order_id', to: 'merchant_orders#update'
  end
end
