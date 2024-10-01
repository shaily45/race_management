Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "races#index"

  resources :races, only: %i[index new create edit update destroy] do
    collection do
      post :reset
    end
  end
end
