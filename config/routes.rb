Rails.application.routes.draw do
  devise_for :users
  get 'plugins/index'

  get 'plugins/create'

  resources :app_configs

  resources :servers do
    resources :ssh_keys
    resources :plugin_instances
    resources :plugins
    member do
      get :sync
    end
    resources :apps do
      member do
        get :sync
        get :run_cmd
        get :deploy
      end
    end
  end
  root to: 'servers#index'

  mount ActionCable.server => '/cable'
end
