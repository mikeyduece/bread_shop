require 'rails_helper'

describe 'User API' do
  before(:all) do
    @user = create(:user)
    @user.recipes = create_list(:recipe, 4)
    @token = TokiToki.encode(@user.attributes)
  end
  context 'Authorization' do
    it 'should return token' do
      get api_v1_auth_amazon_path, params: stub_omniauth

      expect(response).to be_success

      user_json = JSON.parse(response.body, symbolize_names: true)

      expect(user_json[:token]).to match(/^[a-zA-Z0-9\-_]+?\.[a-zA-Z0-9\-_]+?\.([a-zA-Z0-9\-_]+)?$/)
      expect(user_json[:status]).to eq(200)
    end
  end

  context 'User Recipes' do
    it 'returns list of recipes for a user with params' do
      get api_v1_users_recipes_path, params: {token: @token}

      expect(response).to be_success

      recipes = JSON.parse(response.body, symbolize_names: true)

      expect(recipes[:status]).to eq(200)
      expect(recipes[:recipes].count).to eq(4)
    end

    it 'does not return anything without token in params' do
      get api_v1_users_recipes_path

      expect(response).to_not be_success

    end
  end
end
