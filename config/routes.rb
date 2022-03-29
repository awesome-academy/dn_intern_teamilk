Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root to: "pages#home"
    get "pages/home"
    get "products/index"
    resources :products
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
