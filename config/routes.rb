Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'auth_amazon', to: 'authentication#amazon'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
