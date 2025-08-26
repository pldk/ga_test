Rails.application.routes.draw do
  get "users/index"
  get "up" => "rails/health#show", as: :rails_health_check
  resources :users, only: [ :index ]
end
