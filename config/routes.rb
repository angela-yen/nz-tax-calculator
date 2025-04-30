Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "nz_tax_calculator#index"
  post 'calculate', to: 'nz_tax_calculator#calculate'
end
