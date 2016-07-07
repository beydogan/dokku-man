Rails.application.routes.draw do
  resources :app_configs
  resources :apps
  resources :hosts do
    member do
      get :sync
    end
  end
  root to: 'hosts#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
