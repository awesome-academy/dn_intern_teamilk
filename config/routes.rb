Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root to: "pages#home"
    get "home", to: "pages#home"
    resources :products
    # get "login", to: "sessions#new"
    # post "login", to: "sessions#create"
    # delete "logout", to: "sessions#destroy"
    resource :cart
    namespace :admin do
      get "/", to: "base#index"
      resources :products
      resources :categories
      resources :orders
      get "order/status/:id_status", to: "orders#admin_show_by_status", as: "show_order_by_status"
    end
    get "change_size_product_detail/:id", to: "product_details#show", as: "change_size"
    delete "/:product_detail_id/cart", to: "carts#destroy"

    resources :orders
    get "order/status/:id_status", to: "orders#show_by_status", as: "show_order_by_status"
    devise_for :users

    as :user do
      get "login" => "devise/sessions#new"
      post "login" => "devise/sessions#create"
      delete "logout" => "devise/sessions#destroy"
      get "/signup", to: "devise/registrations#new"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
