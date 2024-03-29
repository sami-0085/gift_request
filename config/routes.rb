Rails.application.routes.draw do
  root 'tops#index'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  post '/guest_login', to: 'user_sessions#guest_login'
  resources :password_resets, only: %i[new create edit update]
  resources :users, only: %i[new create show]
  resource :profile, only: %i[show edit update]
  resources :requests
  resources :quests, only: [:show] do
    member do
      get :choice
      post :answer
      get :hint
      get :correct
    end
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
