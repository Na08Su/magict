Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :path => '', :path_names => { :sign_in => 'login', :sign_out => 'logout', :edit => 'profile' }, :controllers => { :omniauth_callbacks => 'omniauth_callbacks' }

  get 'pages/about'
  get '/myprojects' => 'projects#list'
  post '/free' => 'charges#free'
  root 'projects#index'

  resources :projects do
    resources :tasks, only: [:show]
  end
end
