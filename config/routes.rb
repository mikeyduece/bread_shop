# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :users do
        # Like routes
        post ':id/like/:recipe_id', to: 'likes#create'
        delete ':id/unlike/:recipe_id', to: 'likes#destroy'

        # Feed routes
        scope path: ':id/feeds', controller: :feeds, as: 'feed' do
          get 'me', to: 'feeds#user'
          get 'flat', to: :flat
          get 'aggregated', to: :aggregated
          get 'notification', to: :notification
        end

        # Follow routes
        post ':id/follow/:target_id', to: 'follows#create'
        delete ':id/unfollow/:target_id', to: 'follows#destroy'

        # all users path
        get 'all', to: 'users#index'

        # Specific users recipe paths
        get ':id/recipes', to: 'recipes#index'
        get ':id/recipes/:recipe_id', to: 'recipes#show'
        post ':id/recipes', to: 'recipes#create'
        delete ':id/recipes/:recipe_id', to: 'recipes#destroy'
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
