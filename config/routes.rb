Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :plants do 
    resources :rentals, only: [:create] 
  end
  resources :rentals, only: [:index, :show]
  resource :dashboards, only: [:show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
