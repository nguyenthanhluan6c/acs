Rails.application.routes.draw do
  root "payslips#index"
  devise_for :users
  resources :users
  resources :salaries
  resources :payslips
  resources :timesheets
  namespace :admin do
    root "admin_settings#index"
    resources :admin_settings
    resources :columns
    resources :formulas
  end
end
