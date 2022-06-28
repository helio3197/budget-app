Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { edit: 'account' }

  # devise_scope :user do
  #   get 'sign_in', to: 'devise/sessions#new'
  #   get 'sign_up', to: 'devise/registrations#new'
  #   get 'account', to: 'devise/registrations#edit'
  #   get 'password/new', to: 'devise/passwords#new'
  #   get 'password/edit', to: 'devise/passwords#edit'
  # end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
