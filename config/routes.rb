Tissues::Application.routes.draw do

  devise_for :users

  resources :users
  resources :projects
  resources :issues
  resources :comments

  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/about"

  match "/users/destroy_avatar/:id" => "users#destroy_avatar", :as => :destroy_avatar
  match "/project/archive/:id" => "projects#archive", :as => :archive_project
  match "/project/reopen/:id" => "projects#reopen", :as => :reopen_project

  match "/issue/solve/:id/done" => "issues#done_solving", :as => :done_solving
  match "/issue/solve/:id/abandon" => "issues#abandon_solving", :as => :abandon_solving
  match "/issue/solve/:id" => "issues#solve", :as => :solve_issue

  match "/issue/validate/:id/abandon" => "issues#abandon_validation", :as => :abandon_validation
  match "/issue/validate/:id/:status" => "issues#done_validating", :as => :done_validating
  match "/issue/validate/:id" => "issues#validate", :as => :validate_issue

  match "/issue/details/:id" => "issues#details", :as => :issue_details

  root :to => "static_pages#home"
end
