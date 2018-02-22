require 'rails_helper'

describe 'User API' do
  before(:each) do
    @user = create(:user)
    @user.recipes = create_list(:recipe, 4)
    @user.recipes.each {|x| x.recipe_ingredients = create_list(:recipe_ingredient, 6)}
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

  context 'user recipes' do
    it 'returns list of recipes for a user with params' do
      get "/api/v1/users/#{@user.name}/recipes", params: {token: @token}

      expect(response).to be_success

      recipes = JSON.parse(response.body, symbolize_names: true)

      expect(recipes[:status]).to eq(200)
      expect(recipes[:recipes].count).to eq(4)
    end

    it 'does not return anything without token in params' do
      get "/api/v1/users/#{@user.name}/recipes"

      expect(response).to_not be_success
      expect(response).to have_http_status(401)
    end

    it 'returns recipe with ingredients and total percentage' do
      recipe = @user.recipes[0]
      flour  = create(:ingredient, name: 'Flour')
      recipe.recipe_ingredients << create(:recipe_ingredient, ingredient_id: flour.id)
      get "/api/v1/users/#{@user.name}/recipes/#{recipe.name}", params: {token: @token}

      expect(response).to be_success

      json_recipe = JSON.parse(response.body, symbolize_names: true)

      expect(json_recipe[:status]).to eq(200)
      expect(json_recipe[:recipe][:name]).to eq(recipe.name)
      expect(json_recipe[:recipe][:ingredients].length).to eq(7)
    end

    it 'user can create recipe' do
      list = {
              name: 'Baguette',
              ingredients: {'Flour' => {amount: 1.00},
                            'Water' => {amount: 0.62},
                            'Yeast' => {amount: 0.02},
                            'Salt'  => {amount: 0.02}},
             }

      post "/api/v1/users/#{@user.name}/recipes", params: {token: @token, recipe: list}

      expect(response).to be_success

      new_recipe = JSON.parse(response.body, symbolize_names: true)

      expect(Recipe.exists?(name: 'Baguette')).to be(true)
      expect(Ingredient.any? {|x| list[:ingredients].keys}).to be(true)
      expect(RecipeIngredient.any? {|x| list[:ingredients].values}).to be(true)
    end
  end
end
