Didh::Application.routes.draw do

  devise_for :users
  devise_for :admins

  match 'debates/' => 'debates#index'
  match 'debates/part/:id' => 'debates#index'
  match 'debates/text/:id' => 'debates#index'
  match 'debates/text/:id/auth' => 'debates#index'
  match 'debates/text/:id/comment/:sentence' => 'debates#index'

  match 'static/debates/text/:id' => 'debates#show'
  match 'debates/hide_instructions' => 'debates#hide_instructions'
  match 'debates/show_instructions' => 'debates#show_instructions'

  match 'book/' => 'pages#book'
  match 'about/' => 'pages#sendMessage', :as => 'about', :via => :post
  match 'about/' => 'pages#about'
  match 'news/' => 'pages#news'
  match 'pages/*page' => 'pages#development', :via => :get

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
