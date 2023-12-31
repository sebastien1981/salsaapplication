Rails.application.routes.draw do
  get 'dances/new'
  get 'schools/new'
  devise_for :users
  root to: "schools#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :schools do
    resources :school_classes
    get '/dashboard', to: 'school_classes#dashboard'
    resources :teachers
    get '/advancedsearch', to: 'teachers#advancedsearch'
  end
  resources :dances
end
