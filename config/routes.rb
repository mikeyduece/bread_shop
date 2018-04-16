Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :users do
        scope path: ':email/feeds', constraints: { email: /.+@.+\..*/ }, controller: :feeds, as: 'feed' do
          get 'me', to: 'feeds#user'
          get 'flat', to: :flat
          get 'aggregated', to: :aggregated
          get 'notification', to: :notification
        end

        get ':email/follow/:target_email', to: 'follows#create',
          constraints: { email: /.+@.+\..*/, target_email: /.+@.+\..*/}
        delete ':email/unfollow/:target_email', to: 'follows#destroy',
          constraints: { email: /.+@.+\..*/, target_email: /.+@.+\..*/}
        get 'all', to: 'users#index'
        get ':email/recipes', to: 'recipes#index', constraints: { email: /.+@.+\..*/ }
        get ':email/recipes/:recipe_name', to: 'recipes#show', constraints: { email: /.+@.+\..*/ }
        post ':email/recipes', to: 'recipes#create', constraints: { email: /.+@.+\..*/ }
        delete ':email/recipes/:recipe_name', to: 'recipes#destroy', constraints: { email: /.+@.+\..*/ }
      end

      get 'auth_amazon', to: 'authentication#amazon'
      get 'families', to: 'families#index'
      get 'families/:family_name', to: 'families#show'
      get 'recipes/:recipe_name/new_totals', to: 'recipes#show'
    end
  end
end
