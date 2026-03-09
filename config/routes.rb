Rails.application.routes.draw do
  get "/about", to: "static_pages#about"
  devise_for :users
  root to: "requests#index"
  get "requests/new"
  get "requests/create"
  get "requests/edit"
  get "requests/update"
  get "requests/destroy"
  get "requests/request_params"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :requests, only: [:index, :show, :create, :destroy, :update] do
    resources :chats, only: [:create]
  end

  resources :chats, only: :show do
    resources :messages, only: [:create]
  end

  get "about_us", to: "pages#about_us"
  get "cyrille", to: "pages#cyrille"
  get "loic", to: "pages#loic"
  get "marc", to: "pages#marc"


  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
