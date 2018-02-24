Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :users do
        get ':user_name/recipes', to: 'recipes#index'
        get ':user_name/recipes/:recipe_name', to: 'recipes#show'
        post ':user_name/recipes', to: 'recipes#create'
        delete ':user_name/recipes/:recipe_name', to: 'recipes#destroy'
      end
      get 'auth_amazon', to: 'authentication#amazon'
    end
  end
end
