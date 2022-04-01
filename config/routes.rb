Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root to: "pages#home"
    get "pages/home"
    resources :products
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    get "cart", to: "carts#index"
    post "add_to_cart/:id", to: "carts#create", as: "add_to_cart"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
