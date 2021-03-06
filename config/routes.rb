Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users do
    post 'toggle_closed', on: :member
  end
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :places, only: [:index, :show]
  resources :styles, only: [:index, :show]

  root 'breweries#index'

  #get 'ratings', to: 'ratings#index'
  #get 'ratings/new', to: 'ratings#new'
  #post 'ratings', to: 'ratings#create'

  resources :ratings, only: [:index, :new, :create, :destroy]

  resource :session, only: [:new, :create, :destroy]

  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  get 'places', to: 'places#index'
  post 'places', to:'places#search'
  get 'beerlist', to:'beers#list'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
