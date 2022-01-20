Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resource :subjects, only: %i[index create destroy] do # TODO: update
    resource :questions, only: %i[index new create] # TODO: edit update destroy
  end
end
