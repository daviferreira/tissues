Tissues::Application.routes.draw do
  devise_for :users

  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/about"

  root :to => "static_pages#home"
end
