Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "static_pages#home"

  get "/about", to: "static_pages#about", as: :about
  get "/user-guide", to: "static_pages#user_guide", as: :user_guide
  get "/search/advanced", to: "searches#advanced", as: :search_advanced
  get "/robots.txt", to: "robots#index", defaults: { format: :text }

  scope path: "/explore" do
    resources :metadata, only: %i[index show], path: "data" do
      resources :datasets, only: [] do
        get :show, on: :member, defaults: { format: :json }
      end
      get :search, on: :collection
    end

    resources :communities, only: %i[index show] do
      member do
        get :general
        get :power_generation, path: "power-generation"
        get :electric_rates_sales, path: "electric-rates-sales"
        get :fuel
        get :demographics
        get :income
      end

      resources :charts, only: [], controller: "communities/charts", defaults: { format: :json } do
        collection do
          get :generation_monthly
          get :capacity_yearly
          get :population_employment
          get :population_detail
          get :generation_yearly
          get :fuel_prices
          get :bulk_fuel_capacity_mix
          get :sex_distribution
          get :age_distribution
          get :poverty_rate
          get :household_income_brackets
          get :income
          get :fuel_prices
          get :electricity_consumption_by_sector
          get :electricity_consumption_per_customer
          get :electricity_revenue
          get :electricity_customers
          get :electric_rates
        end
      end

      resources :maps, only: [], controller: "communities/maps", defaults: { format: :json } do
        collection do
          get :house_districts
          get :senate_districts
          get :service_area_geom
          get :service_area
          get :plants
          get :bulk_fuel_facilities
        end
      end
    end

    concern :summarizable do |options|
      member do
        get :general
        get :power_generation, path: "power-generation"
      end

      resources :charts, only: [], module: options[:resource_name], defaults: { format: :json } do
        collection do
          get :generation_monthly
          get :capacity_yearly
          get :generation_yearly
        end
      end

      resources :maps, only: [], module: options[:resource_name], defaults: { format: :json } do
        collection do
          get :community_locations
          get :service_areas
          get :plants
        end
      end
    end

    resources :grids, only: %i[index show] do
      concerns :summarizable, resource_name: :grouped_summaries
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
