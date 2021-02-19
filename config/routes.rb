Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :plants do 
    resources :rentals, only: [:create]
  end
  resources :rentals, only: [:index, :show] do 
    member do 
      patch 'accept'
      patch 'deny'
    end
  end
  resource :dashboards, only: [:show]

  #host/rentals/:id/accept => member
  #host/rentals/:id/deny
  #host/rentals/test => collection
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

