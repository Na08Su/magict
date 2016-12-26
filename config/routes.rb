Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :path => '', :path_names => { :sign_in => 'login', :sign_out => 'logout', :edit => 'profile' }, :controllers => { :omniauth_callbacks => 'omniauth_callbacks' }

  get  'pages/about'
  get  'pages/landing' => 'pages#landing'
  get  '/myprojects' => 'projects#list'
  post '/free' => 'charges#free'
  post '/pay'  => 'charges#pay'
  
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
