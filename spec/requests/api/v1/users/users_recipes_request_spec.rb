require 'rails_helper'

RSpec.describe 'User API' do
  let(:user) { create(:user_with_recipes) }
  let!(:token) { TokiToki.encode(user.attributes) }

  context 'Authorization' do
    it 'should return token' do
      get api_v1_auth_amazon_path, params: stub_omniauth

      expect(response).to be_successful

      user_json = JSON.parse(response.body, symbolize_names: true)
      require 'pry'; binding.pry

      expect(user_json[:user][:name]).to eq(stub_omniauth['user_info']['info']['name'])
      expect(user_json[:token]).to match(/^[a-zA-Z0-9\-_]+?\.[a-zA-Z0-9\-_]+?\.([a-zA-Z0-9\-_]+)?$/)
      expect(user_json[:status]).to eq(200)
    end
  end

  context 'user recipes' do
    it 'returns list of recipes for a user with params' do
      get "/api/v1/users/#{user.email}/recipes", params: { token: token }

      expect(response).to be_successful

      recipes = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(recipes.count).to eq(4)
    end

    it 'does not return anything without token in params' do
      get "/api/v1/users/#{user.email}/recipes"

      expect(response).to_not be_successful
      expect(response).to have_http_status(401)
    end

    it 'returns recipe with ingredients and total percentage' do
      recipe = user.recipes[0]
      recipe.recipe_ingredients.clear
      flour  = create(:ingredient, name: 'flour')
      recipe.recipe_ingredients << create(:recipe_ingredient, ingredient_id: flour.id)
      6.times do
        create(:recipe_ingredient, recipe: recipe)
      end

      get "/api/v1/users/#{user.email}/recipes/#{recipe.name}",
        params: { token: token }

      expect(response).to be_successful

      json_recipe = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(json_recipe[:recipe][:name]).to eq(recipe.name)
      expect(json_recipe[:recipe][:id]).to eq(recipe.id)
      expect(json_recipe[:recipe][:ingredients].length).to eq(7)
    end

    it 'can create recipe' do
      VCR.use_cassette('new_recipes') do
        list = {
          name: 'baguette',
          ingredients: {
            flour: { amount: 1.00 },
            water: { amount: 0.62 },
            yeast: { amount: 0.02 },
            salt: { amount: 0.02 }
          }
        }

        post "/api/v1/users/#{user.email}/recipes",
          params: { token: token, recipe: list }

        expect(response).to be_successful

        new_recipe = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(201)
        expect(new_recipe[:recipe][:id]).to eq(user.recipes.last.id)
        expect(new_recipe[:recipe][:name]).to eq(user.recipes.last.name)
        expect(Recipe.exists?(name: 'baguette')).to be(true)
        expect(Ingredient.any? { list[:ingredients].keys }).to be(true)
        expect(RecipeIngredient.any? { list[:ingredients].values }).to be(true)
      end
    end

    it 'cannot create a recipe with same name as one that already exists' do
      VCR.use_cassette('dupe_recipes') do
        user.recipes.clear
        user.recipes << create(:recipe, name: 'baguette')
        list = {
          name: 'baguette',
          ingredients: {
            flour: { amount: 1.00 },
            water: { amount: 0.62 },
            yeast: { amount: 0.02 },
            salt: { amount: 0.02 }
          }
        }

        post "/api/v1/users/#{user.email}/recipes",
          params: { token: token, recipe: list }

        expect(response).not_to be_successful

        result = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)
        expect(result[:message]).to eq('You already have a recipe with that name')
      end
    end

    it 'can assign a tag to a recipe' do
      VCR.use_cassette('tags') do
        list = {
          name: 'baguette',
          ingredients: {
            flour: { amount: 1.00 },
            water: { amount: 0.62 },
            yeast: { amount: 0.02 },
            salt: { amount: 0.02 }
          }
        }
        tags = %w[Lean Baguette French\ Bread]

        post "/api/v1/users/#{user.email}/recipes",
          params: { token: token, recipe: list, tags: tags }

        expect(response).to be_successful

        recipe = JSON.parse(response.body, symbolize_names: true)

        expect(recipe[:tags]).to include(*tags)
      end
    end

    it 'user can delete recipe' do
      VCR.use_cassette('formatting') do
        recipe = user.recipes[0]
        flour  = create(:ingredient, name: 'Flour')
        recipe.recipe_ingredients << create(:recipe_ingredient, ingredient_id: flour.id)

        delete "/api/v1/users/#{user.email}/recipes/#{recipe.name}",
          params: { token: token }

        expect(response).to be_successful

        deleted = JSON.parse(response.body, symbolize_names: true)

        expect(deleted[:status]).to eq(204)
        expect(deleted[:message]).to eq("Successfully deleted #{recipe.name}")
        expect(Recipe.all).not_to include(recipe.id)
      end
    end

    it 'returns the family of the recipe' do
      VCR.use_cassette('family') do
        list = {
          name: 'baguette',
          ingredients: {
            flour: { amount: 1.00 },
            water: { amount: 0.62 },
            yeast: { amount: 0.02 },
            salt: { amount: 0.02 }
          }
        }
        post "/api/v1/users/#{user.email}/recipes",
          params: { recipe: list, token: token }

        get "/api/v1/users/#{user.email}/recipes/#{list[:name]}",
          params: { token: token }

        expect(response).to be_successful

        return_recipe = JSON.parse(response.body, symbolize_names: true)

        expect(return_recipe[:recipe][:family]).to eq('Lean')
      end
    end

    it 'returns list of recipes that align with requested family' do
      VCR.use_cassette('formatting') do
        recipe = user.recipes[0]

        get "/api/v1/families/#{recipe.family.name}", params: { token: token }

        expect(response).to be_successful

        family = JSON.parse(response.body, symbolize_names: true)

        expect(family[:name]).to eq(recipe.family.name)
        expect(family[:recipes].empty?).not_to be true
      end
    end
  end

  context 'calculate new amounts' do
    it 'calculates new amounts from new total dough weight' do
      VCR.use_cassette('new_recipes') do
        list = {
          name: 'french baguette',
          ingredients: {
            flour: { amount: 1.00 },
            water: { amount: 0.62 },
            yeast: { amount: 0.02 },
            salt: { amount: 0.02 }
          }
        }

        post "/api/v1/users/#{user.email}/recipes", params: {
          token: token,
          recipe: list
        }

        original_recipe = JSON.parse(response.body, symbolize_names: true)

        get "/api/v1/recipes/#{original_recipe[:recipe][:name].parameterize}/new_totals", params: {
          token: token,
          recipe: original_recipe[:recipe],
          new_dough_weight: 3.32
        }

        expect(response).to be_successful

        new_totals = JSON.parse(response.body, symbolize_names: true)

        expect(new_totals[:ingredients][:flour][:amount]).to eq(2.0)
        expect(new_totals[:ingredients][:water][:amount]).to eq(1.24)
        expect(new_totals[:ingredients][:yeast][:amount]).to eq(0.04)
        expect(new_totals[:ingredients][:salt][:amount]).to eq(0.04)
      end
    end

    it 'calculates different amounts from different total dough weight' do
      VCR.use_cassette('recipes') do
        list = {
          name: 'baguette',
          ingredients: {
            flour: { amount: 1.00 },
            water: { amount: 0.62 },
            yeast: { amount: 0.02 },
            salt: { amount: 0.02 }
          }
        }

        post "/api/v1/users/#{user.email}/recipes", params: {
          token: token,
          recipe: list
        }

        original_recipe = JSON.parse(response.body, symbolize_names: true)

        get "/api/v1/recipes/#{original_recipe[:recipe][:name]}/new_totals", params: {
          token: token,
          recipe: original_recipe[:recipe],
          new_dough_weight: 10.0
        }

        expect(response).to be_successful

        new_totals = JSON.parse(response.body, symbolize_names: true)

        expect(new_totals[:ingredients][:flour][:amount]).to eq(6.02)
        expect(new_totals[:ingredients][:water][:amount]).to eq(3.73)
        expect(new_totals[:ingredients][:yeast][:amount]).to eq(0.12)
        expect(new_totals[:ingredients][:salt][:amount]).to eq(0.12)
      end
    end
  end
end
