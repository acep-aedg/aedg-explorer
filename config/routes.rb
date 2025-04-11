Rails.application.routes.draw do
  resources :metadata, only: [:index, :show], path: 'data' do
    resources :datasets, only: [:show] do 
      get :download, on: :member
    end
    get :search, on: :collection
    get :download, on: :member
  end

  resources :boroughs, only: [:index]

  resources :communities, only: [:index, :show] do
    resources :charts, only: [] , controller: "communities/charts", defaults: { format: :json } do
      collection do
        get :production_monthly # Creates production_monthly_community_charts_path
        get :capacity_yearly
        get :population_employment
        get :population_detail
        get :production_yearly
      end
    end

    resources :maps, only: [] , controller: "communities/maps", defaults: { format: :json }do
      collection do
        get :house_districts
        get :senate_districts
      end
    end
  end

  get 'welcome/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "welcome#index"
end
