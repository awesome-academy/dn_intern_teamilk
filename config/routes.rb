Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root to: "pages#home"
    get "home", to: "pages#home"
    resources :products
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    resource :cart
    namespace :admin do
        get "/", action: :index
    end
    get "change_size_product_detail/:id", to: "product_details#show", as: "change_size"
    delete "/:product_detail_id/cart", to: "carts#destroy"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
