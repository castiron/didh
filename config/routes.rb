Didh::Application.routes.draw do

  devise_for :users
  devise_for :admins

  match 'debates/' => 'debates#index', :via => :get
  match 'debates/part/:id' => 'debates#index', :via => :get
  match 'debates/text/:id' => 'debates#index', :via => :get
  match 'debates/text/:id/auth' => 'debates#index', :via => :get
  match 'debates/text/:id/comment/:sentence' => 'debates#index', :via => :get

  match 'static/debates/text/:id' => 'debates#show', :via => :get
  match 'debates/hide_instructions' => 'debates#hide_instructions', :via => :get
  match 'debates/show_instructions' => 'debates#show_instructions', :via => :get

  match 'book/' => 'pages#book', :via => :get
  match 'apis/' => 'pages#apis', :via => :get
  match 'about/' => 'pages#sendMessage', :as => 'about', :via => :post
  match 'about/' => 'pages#about', :via => :get
  match 'news/' => 'pages#news', :via => :get

  resources :comments, :only => [:index]
  resources :texts, :only => [:index, :show, :destroy] do
    resources :comments, :only => [:index, :create, :show, :destroy]
    resources :annotations, :only => [:index, :show, :create]
    resources :sentences, :only => [:index, :show]
    resources :keywords, :only => [:index, :create]
  end

  namespace :admin do
    root :to => 'texts#index'
    resources :texts
    resources :editions
    resources :parts
  end

  root :to => 'pages#index'

end
