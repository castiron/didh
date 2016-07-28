Didh::Application.routes.draw do

  devise_for :users
  devise_for :admins

  get 'debates/' => 'debates#index'
  get 'debates/:edition_id' => 'debates#index'
  get 'debates/part/:part_id' => 'debates#index'
  get 'debates/text/:text_id' => 'debates#index'
  get 'debates/text/:text_id/auth' => 'debates#index'
  get 'debates/text/:text_id/comment/:sentence_id' => 'debates#index'

  get 'static/debates/text/:id' => 'debates#show'
  get 'debates/hide_instructions' => 'debates#hide_instructions'
  get 'debates/show_instructions' => 'debates#show_instructions'

  get 'book/' => 'pages#book'
  get 'book/:id' => 'pages#book'
  get 'apis/' => 'pages#apis'
  post 'about/' => 'pages#sendMessage', :as => 'about'
  get 'about/' => 'pages#about'
  get 'cfps/' => 'pages#cfps'
  get 'cfps/cfp_2015_ddh' => 'pages#cfp_2015_ddh'
  get 'cfps/cfp_2017_ddh' => 'pages#cfp_2017_ddh'
  get 'cfps/cfp_2015_mhm' => 'pages#cfp_2015_mhm'
  get 'news/' => 'pages#news'

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
