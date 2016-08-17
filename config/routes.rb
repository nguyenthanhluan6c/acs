Rails.application.routes.draw do
  root "users#index"
  devise_for :users
  resources :users
  resources :salaries
  resources :payslips
  resources :timesheets
  namespace :admin do
    root "admin_settings#index"
    resources :admin_settings
  end
end
