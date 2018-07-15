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
        post ':id/follow/:target_id', to: 'follows#create'#, constraints: { email: /.+@.+\..*/, target_id: /.+@.+\..*/ }
        delete ':email/unfollow/:target_email', to: 'follows#destroy'#, constraints: { email: /.+@.+\..*/, target_email: /.+@.+\..*/ }

        # all users path
        get 'all', to: 'users#index'

        # Specific users recipe paths
        get ':id/recipes', to: 'recipes#index'#, constraints: { email: /.+@.+\..*/ }
        get ':id/recipes/:recipe_id', to: 'recipes#show'#, constraints: { email: /.+@.+\..*/ }
        post ':id/recipes', to: 'recipes#create'#, constraints: { email: /.+@.+\..*/ }
        delete ':id/recipes/:recipe_id', to: 'recipes#destroy'#, constraints: { email: /.+@.+\..*/ }
      end

      # log in with amazon
      get 'auth_amazon', to: 'authentication#amazon'

      # Recipe family paths
      get 'families/:family_name', to: 'families#show'

      # new total weights path
      get 'new_totals', to: 'new_totals#show'

      # get nutrition label for recipe
      get 'recipes/:id/label', to: 'nutrition_label#show'

      # get all recipes and specific recipes
      get 'recipes/:id', to: 'recipes#show'
      get 'recipes', to: 'recipes#index'
    end
  end
end
