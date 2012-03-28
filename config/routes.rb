Tissues::Application.routes.draw do

  devise_for :users
  resources :users
  resources :projects
  resources :issues

  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/about"
  
  match "/project/archive/:id" => "projects#archive", :as => :archive_project

  root :to => "static_pages#home"
end
