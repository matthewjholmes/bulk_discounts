Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'welcome#index'

  resources :merchants, only: :index do
    get '/dashboard', controller: :merchants, action: :show, as: 'dashboard'
    resources :bulk_discounts
    resources :items, except: [:delete]
    resources :invoices, only: [:index, :show]
    resources :invoice_items, only: :update
  end

  namespace :admin do
    root to: 'dashboard#index', as: 'dashboard'
    resources :merchants, only: [:index, :show, :edit, :update, :new, :create]
    resources :invoices, only: [:index, :show]
    resources :invoice_items, only: :update
  end

end
