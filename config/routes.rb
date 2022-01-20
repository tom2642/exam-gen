Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get '/dashboard', to: 'subjects#index', as: 'dashboard'
  resource :subjects, only: %i[create destroy] do # TODO: update
    resource :questions, only: %i[index new create] # TODO: edit update destroy
  end
end
