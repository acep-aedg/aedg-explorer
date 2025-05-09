Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'static_pages#home'

  get '/home', to: 'static_pages#home', as: :home
  get '/about', to: 'static_pages#about', as: :about
  get '/user_guide', to: 'static_pages#user_guide', as: :user_guide
  get '/data_explorer', to: 'datasets#index', as: :data_explorer

  scope path: '/explore' do
    resources :metadata, only: %i[index show], path: 'data' do
      resources :datasets, only: [:show] do
        get :download, on: :member
      end
      get :search, on: :collection
      get :download, on: :member
    end

    resources :communities, only: %i[index show] do
      resources :charts, only: [], controller: 'communities/charts', defaults: { format: :json } do
        collection do
          get :production_monthly # Creates production_monthly_community_charts_path
          get :capacity_yearly
          get :population_employment
          get :population_detail
          get :production_yearly
          get :fuel_prices
        end
      end

      resources :maps, only: [], controller: 'communities/maps', defaults: { format: :json } do
        collection do
          get :house_districts
          get :senate_districts
        end
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
end
