Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users
      resources :sessions, only: :create
      resources :namespaces, only: [:index, :show, :update]
      resources :holons, only: [:create, :show]
    end
  end


  namespace :admin do
    resources :users
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
