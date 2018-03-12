Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :users do
        get ':email/recipes', to: 'recipes#index', constraints: {email: /.+@.+\..*/}
        get ':email/recipes/:recipe_name', to: 'recipes#show', constraints: {email: /.+@.+\..*/}
        post ':email/recipes', to: 'recipes#create', constraints: {email: /.+@.+\..*/}
        delete ':email/recipes/:recipe_name', to: 'recipes#destroy', constraints: {email: /.+@.+\..*/}
      end
      get 'auth_amazon', to: 'authentication#amazon'
      get 'families', to: 'families#index'
      get 'families/:family_name', to: 'families#show'
    end
  end
end
