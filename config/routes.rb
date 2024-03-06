Rails.application.routes.draw do
  get 'users/new'
  get 'users/create'
  root 'tops#index'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resources :users, only: %i[new create show]
  resources :requests
  get 'search', to: 'requests#search'
end
