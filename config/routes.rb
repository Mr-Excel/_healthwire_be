Rails.application.routes.draw do

    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users 
      resources :items 
    end
  end

  get '/api/v1/items/mapped/:practice_id' , to: 'api/v1/items#mapped_items'
  post '/api/v1/items/mapped/all', to: 'api/v1/items#create_map_items'
  get '/api/v1/items/practices/all' , to: 'api/v1/items#practices'
  post '/api/v1/items/:type', to: 'api/v1/items#create'
  get '/api/v1/items/:practice_id', to: 'api/v1/items#index'
  get '/api/v1/items/full/:practice_id', to: 'api/v1/items#fullMatch'
  get '/api/v1/items/exact/:practice_id', to: 'api/v1/items#exactMatch'
  get '/api/v1/items/low/:practice_id', to: 'api/v1/items#lowMatch'
  get '/api/v1/items/remaining/:practice_id', to: 'api/v1/items#remaining'

  
  
  

  post '/api/v1/auth/login', to: 'api/v1/authentication#login'
  get '/*a', to: 'application#not_found'
  
  # Defines the root path route ("/")
  # root "articles#index"
end
