Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'static_pages#home'

  get '/about', to: 'static_pages#about', as: :about
  get '/user-guide', to: 'static_pages#user_guide', as: :user_guide

  scope path: '/explore' do
    resources :metadata, only: %i[index show], path: 'data' do
      resources :datasets, only: [] do
        get :download, on: :member
        get :show, on: :member, defaults: { format: :json }
      end
      get :search, on: :collection
      get :download, on: :member
    end

    resources :communities, only: %i[index show] do
      resources :charts, only: [], controller: 'communities/charts', defaults: { format: :json } do
        collection do
          get :production_monthly
          get :capacity_yearly
          get :population_employment
          get :population_detail
          get :production_yearly
          get :fuel_prices
          get :average_sales_rates
          get :revenue_by_customer_type
          get :customers_by_customer_type
          get :sales_by_customer_type
          get :bulk_fuel_capacity_mix
        end
      end

      resources :maps, only: [], controller: 'communities/maps', defaults: { format: :json } do
        collection do
          get :house_districts
          get :senate_districts
          get :service_area_geoms
          get :service_areas
          get :plants
          get :bulk_fuel_facilities
        end
      end

      resource :summary, only: [], controller: 'communities/summaries' do
        get :capacity
        get :monthly_generation
      end
    end
    resources :grids, only: %i[index show] do
      resources :charts, only: [], controller: 'grids/charts', defaults: { format: :json } do
        collection do
          get :production_monthly
          get :capacity_yearly
          get :production_yearly
        end
      end

      resources :maps, only: [], controller: 'grids/maps', defaults: { format: :json } do
        collection do
          get :community_locations
          get :service_area_geoms
        end
      end

      resource :summary, only: [], controller: 'grids/summaries' do
        get :capacity
        get :monthly_generation
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
end
