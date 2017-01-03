Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :path => '', :path_names => { :sign_in => 'login', :sign_out => 'logout', :edit => 'profile' }, :controllers => { :omniauth_callbacks => 'omniauth_callbacks' }

  get  'pages/about'
  get  'pages/javasc_pra' => 'pages#javasc_pra'
  get  'pages/landing' => 'pages#landing'
  get  '/myprojects' => 'projects#list'
  post '/free' => 'charges#free'
  post '/pay'  => 'charges#pay'

  # likeアクションへのルーティングを定義
  post '/like/:request_id' => 'likes#like',as: 'like'
  # unlikeアクションへのルーティングを定義
  delete '/unlike/:request_id' => 'likes#unlike',as: 'unlike'
  
  # constraints ->  request { request.session[:user_id].present? } do
  #   # ログインしてる時のパス
  #   root to: "projects#index"
  # end
  root 'projects#index'
  # root 'pages#landing'

  resources :projects do
    resources :tasks, only: [:show]
  end

  resources :projects do
    resources :reviews, only: [:create, :destroy]
  end

  resources :requests
end
