# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Likes' do
  let!(:user_1) { create(:user_with_recipes) }
  let!(:user_2) { create(:user_with_recipes) }
  let!(:token_1) { TokiToki.encode(user_1.attributes) }
  let!(:token_2) { TokiToki.encode(user_2.attributes) }

  it 'can like a recipe' do
    VCR.use_cassette('likes') do
      recipe = user_2.recipes[1]
      expect(user_1.likes.count).to eq(0)

      post "/api/v1/users/#{user_1.id}/like/#{recipe.id}", params: { token: token_1 }

      expect(response).to be_successful

      like = JSON.parse(response.body, symbolize_names: true)

      expect(user_1.likes.count).to eq(1)
      expect(user_1.likes[-1].recipe_id).to eq(recipe.id)
      expect(like[:user_id]).to eq(user_1.id)
      expect(like[:target_id]).to eq(user_2.id)
      expect(like[:recipe_id]).to eq(recipe.id)

      get "/api/v1/users/#{user_2.id}/feeds/notification", params: { token: token_2 }

      notify = JSON.parse(response.body, symbolize_names: true)

      expect(notify.first[:activities].first[:actor][:name]).to eq(user_1.name)
      expect(notify.first[:activities].first[:object][:name]).to eq(recipe.name)
      expect(notify.first[:activities].first[:verb]).to eq('Like')
    end
  end

  it 'can unlike a recipe' do
    VCR.use_cassette('unlike') do
      recipe = user_2.recipes[0]
      expect(user_2.likes.count).to eq(0)

      post "/api/v1/users/#{user_1.id}/like/#{recipe.id}", params: { token: token_1 }

      expect(user_1.likes.count).to eq(1)

      delete "/api/v1/users/#{user_1.id}/unlike/#{recipe.id}", params: { token: token_1 }

      expect(response).to be_successful

      unlike = JSON.parse(response.body, symbolize_names: true)

      expect(user_1.likes.count).to eq(0)
      expect(unlike[:status]).to eq(204)
      expect(unlike[:message]).to eq("You have unliked #{recipe.name}")
    end
  end
end
