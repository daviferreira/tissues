Tissues::Application.routes.draw do
  get "projects/index"

  get "projects/show"

  get "projects/new"

  devise_for :users
  resources :users

  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/about"

  root :to => "static_pages#home"
end
