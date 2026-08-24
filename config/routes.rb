Rails.application.routes.draw do
  resources :events, only: [:index] do
    resources :votes, only: [:create]
  end

  root "events#index"
end
