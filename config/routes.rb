# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :users do
        # Like routes
        post ':email/like/:recipe_id', to: 'likes#create', constraints: { email: /.+@.+\..*/ }

        delete ':email/unlike/:recipe_id', to: 'likes#destroy', constraints: { email: /.+@.+\..*/ }

        # Feed routes
        scope path: ':email/feeds', constraints: { email: /.+@.+\..*/ }, controller: :feeds, as: 'feed' do
          get 'me', to: 'feeds#user'
          get 'flat', to: :flat
          get 'aggregated', to: :aggregated
          get 'notification', to: :notification
        end

        # Follow routes
        post ':email/follow/:target_email', to: 'follows#create', constraints: { email: /.+@.+\..*/, target_email: /.+@.+\..*/ }
        delete ':email/unfollow/:target_email', to: 'follows#destroy', constraints: { email: /.+@.+\..*/, target_email: /.+@.+\..*/ }

        # all users path
        get 'all', to: 'users#index'

        # Specific users recipe paths
        get ':email/recipes', to: 'recipes#index', constraints: { email: /.+@.+\..*/ }
        get ':email/recipes/:recipe_name', to: 'recipes#show', constraints: { email: /.+@.+\..*/ }
        post ':email/recipes', to: 'recipes#create', constraints: { email: /.+@.+\..*/ }
        delete ':email/recipes/:recipe_name', to: 'recipes#destroy', constraints: { email: /.+@.+\..*/ }
      end

      # log in with amazon
      get 'auth_amazon', to: 'authentication#amazon'

      # Recipe family paths
      get 'families', to: 'families#index'
      get 'families/:family_name', to: 'families#show'

      # new total weights path
      get 'recipes/:recipe_name/new_totals', to: 'recipes#show'
    end
  end
end
