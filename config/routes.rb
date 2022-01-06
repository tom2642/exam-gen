Rails.application.routes.draw do
  get 'questions/index'
  get 'questions/new'
  get 'questions/create'
  get 'questions/show'
  get 'questions/edit'
  get 'questions/update'
  get 'questions/destroy'
  devise_for :users
  root to: 'pages#home'
  resource :question
end
