Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { edit: 'account' }, controllers: { registrations: 'registrations',
                                                                               sessions: 'sessions' }

  resources :categories do
    resources :operations, except: %i[index show]
  end

  resources :operations, only: %i[index show]

  get 'categories/:id/operations', to: redirect('categories/%{id}')

  get 'my_budget', to: 'budget#index'
  get 'my_budget/deposit', to: 'budget#new_deposit'
  post 'my_budget/deposit', to: 'budget#exec_deposit'
  get 'my_budget/withdraw', to: 'budget#new_withdraw'
  post 'my_budget/withdraw', to: 'budget#exec_withdraw'

  # devise_scope :user do
  #   get 'sign_in', to: 'devise/sessions#new'
  #   get 'sign_up', to: 'devise/registrations#new'
  #   get 'account', to: 'devise/registrations#edit'
  #   get 'password/new', to: 'devise/passwords#new'
  #   get 'password/edit', to: 'devise/passwords#edit'
  # end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "categories#index"
end
