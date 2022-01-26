Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get '/dashboard', to: 'subjects#index', as: :dashboard
  resources :subjects, only: %i[create destroy] do # TODO: update
    resources :questions, only: %i[index new create] # TODO: edit update destroy
  end
  post '/download_docx', to: 'questions#download_docx', as: :download_docx
  post '/download_demo', to: 'questions#download_demo', as: :download_demo
end
