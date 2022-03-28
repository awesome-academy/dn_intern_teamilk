Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root to: "pages#home"
    get "pages/home"
    get "product/index"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
