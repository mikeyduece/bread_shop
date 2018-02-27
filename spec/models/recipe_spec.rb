require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it {should validate_uniqueness_of :name}
  context 'Instance Methods' do
    it '#flour_amts' do
      user = create(:user)
      recipe = create(:recipe)
      flour_1 = create(:ingredient, name: 'ap flour')
      flour_2 = create(:ingredient, name: 'bread flour')
      rec_ing_1 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour_1.id, amount: 100)
      rec_ing_2 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour_2.id, amount: 300)
      ing = create(:recipe_ingredient)
      recipe.recipe_ingredients = [rec_ing_1, rec_ing_2, ing]

      flour = recipe.flour_amts
      expect(flour).to eq(400)
    end

    it '#total_percentage' do
      user = create(:user)
      recipe = create(:recipe)
      ing_list = create_list(:ingredient, 6)
      flour_1 = create(:ingredient, name: 'AP flour')
      flour_2 = create(:ingredient, name: 'Bread flour')
      rec_ing_1 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour_1.id, amount: 100)
      rec_ing_2 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour_2.id, amount: 300)
      rec_ing_3 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[0].id, amount: 50)
      rec_ing_4 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[1].id, amount: 20)
      rec_ing_5 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[2].id, amount: 10)
      rec_ing_6 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[3].id, amount: 25)
      rec_ing_7 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[4].id, amount: 30)
      rec_ing_8 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[5].id, amount: 20)

      total = recipe.total_percentage

      expect(total).to eq(138.75)
    end

    it 'can have a different #total_percentage' do
      user = create(:user)
      recipe = create(:recipe)
      ing_list = create_list(:ingredient, 6)
      flour_1 = create(:ingredient, name: 'AP flour')
      flour_2 = create(:ingredient, name: 'Bread flour')
      rec_ing_1 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour_1.id, amount: 200)
      rec_ing_2 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour_2.id, amount: 300)
      rec_ing_3 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[0].id, amount: 100.63)
      rec_ing_4 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[1].id, amount: 20)
      rec_ing_5 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[2].id, amount: 10)
      rec_ing_6 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[3].id, amount: 25)
      rec_ing_7 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[4].id, amount: 30)
      rec_ing_8 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[5].id, amount: 20)

      total = recipe.total_percentage

      expect(total).to eq(141.13)
    end

    it '#sweetener_percentage' do
      user = create(:user)
      recipe = Recipe.create!(name: 'dinner rolls', user_id: user.id)
      water = Ingredient.create!(name: 'water')
      yeast = Ingredient.create!(name: 'cake yeast')
      milk = Ingredient.create!(name: 'milk')
      butter = Ingredient.create!(name: 'butter')
      sugar = Ingredient.create!(name: 'sugar')
      flour = Ingredient.create!(name: 'flour')
      salt = Ingredient.create!(name: 'salt')
      water_rec_ing = RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: water.id, amount: 0.7)
      yeast_rec_ing = RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: yeast.id, amount: 0.04)
      milk_rec_ing = RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: milk.id, amount: 0.35)
      butter_rec_ing = RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: butter.id, amount: 0.12)
      sugar_rec_ing = RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: sugar.id, amount: 0.06)
      flour_rec_ing = RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: flour.id, amount: 1.75)
      salt_rec_ing = RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: salt.id, amount: 0.035)

      sweets = recipe.sweetener_percentage

      require 'pry'; binding.pry
      expect(sweets).to eq(3.43)
    end
  end
end
