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

    it 'can calculate more than one type of flour' do
      user = create(:user)
      recipe = create(:recipe)
      flour_1 = create(:ingredient, name: 'ap flour')
      flour_2 = create(:ingredient, name: 'cornmeal')
      flour_3 = create(:ingredient, name: 'flax meal')
      flour_4 = create(:ingredient, name: 'semolina')
      flour_5 = create(:ingredient, name: 'durum')
      flour_6 = create(:ingredient, name: 'spelt')
      rec_ing_1 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour_1.id, amount: 1.00)
      rec_ing_2 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour_2.id, amount: 3.00)
      rec_ing_3 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour_3.id, amount: 3.00)
      rec_ing_4 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour_4.id, amount: 3.00)
      rec_ing_5 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour_5.id, amount: 3.00)
      rec_ing_6 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour_6.id, amount: 3.00)
      ing = create(:recipe_ingredient)
      recipe.recipe_ingredients = [rec_ing_1, rec_ing_2, ing, rec_ing_4, rec_ing_3, rec_ing_5, rec_ing_6]

      flour = recipe.flour_amts

      expect(flour).to eq(16.0)
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

      expect(sweets).to eq(3.43)
    end

    it 'can calculate percentage with more than one sweetener' do
      user = create(:user)
      recipe = Recipe.create!(name: 'flatbread', user_id: user.id)
      bf = Ingredient.create(name: 'bread flour')
      ww = Ingredient.create(name: 'whole wheat flour')
      sugar = Ingredient.create(name: 'sugar')
      bs = Ingredient.create(name: 'brown sugar')
      honey = Ingredient.create(name: 'honey')
      bf_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bf.id, amount: 0.50)
      ww_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ww.id, amount: 0.50)
      sugar_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: sugar.id, amount: 0.25)
      bs_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bs.id, amount: 0.10)
      honey_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: honey.id, amount: 0.05)

      sweets = recipe.sweetener_percentage

      expect(sweets).to eq(40.0)
    end

    it 'can pick out sweeteners with syrup in name' do
      user = create(:user)
      recipe = Recipe.create!(name: 'flatbread', user_id: user.id)
      bf = Ingredient.create(name: 'bread flour')
      cornsyrup = Ingredient.create(name: 'corn syrup')
      sugar = Ingredient.create(name: 'sugar')
      bs = Ingredient.create(name: 'brown sugar')
      honey = Ingredient.create(name: 'honey')
      agave = Ingredient.create(name: 'agave syrup')
      bf_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bf.id, amount: 2.0)
      cs_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: cornsyrup.id, amount: 0.50)
      sugar_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: sugar.id, amount: 0.25)
      bs_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bs.id, amount: 0.10)
      honey_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: honey.id, amount: 0.05)
      agave = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: agave.id, amount: 0.05)

      sweets = recipe.sweetener_percentage

      expect(sweets).to eq(47.5)
    end

    it '#fat_percentage' do
      user = create(:user)
      recipe = Recipe.create!(name: 'flatbread', user_id: user.id)
      bf = Ingredient.create(name: 'bread flour', category: 'flour')
      butter = Ingredient.create(name: 'butter', category: 'fat')
      sugar = Ingredient.create(name: 'sugar', category: 'sweetener')
      bf_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bf.id, amount: 1.0)
      butter_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: butter.id, amount: 0.25)
      sugar_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: sugar.id, amount: 0.05)


      fat = recipe.fat_percentage

      expect(fat).to eq(25.0)
    end

    it '#fat_percentage can calculate with more than one fat' do
      user = create(:user)
      recipe = Recipe.create!(name: 'flatbread', user_id: user.id)
      bf = Ingredient.create(name: 'bread flour', category: 'flour')
      butter = Ingredient.create(name: 'butter', category: 'fat')
      sc = Ingredient.create(name: 'sour cream', category: 'fat')
      bf_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bf.id, amount: 1.0)
      butter_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: butter.id, amount: 0.25)
      sc_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: sc.id, amount: 0.05)


      fat = recipe.fat_percentage

      expect(fat).to eq(30.0)
      expect(fat).not_to eq(130.0)
    end

    it '#fat_percentage can find oils as well' do
      user = create(:user)
      recipe = Recipe.create!(name: 'flatbread', user_id: user.id)
      bf = Ingredient.create(name: 'bread flour', category: 'flour')
      canola = Ingredient.create(name: 'canola oil', category: 'fat')
      evoo = Ingredient.create(name: 'olive oil', category: 'fat')
      bf_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bf.id, amount: 1.0)
      canola_oil_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: canola.id, amount: 0.25)
      evoo_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: evoo.id, amount: 0.05)


      fat = recipe.fat_percentage

      expect(fat).to eq(30.0)
      expect(fat).not_to eq(130.0)
    end

    it '#water_percentage' do
      user = create(:user)
      recipe = Recipe.create!(name: 'flatbread', user_id: user.id)
      bf = Ingredient.create(name: 'bread flour', category: 'flour')
      water = Ingredient.create(name: 'water', category: 'fat')
      evoo = Ingredient.create(name: 'olive oil', category: 'fat')
      bf_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bf.id, amount: 1.0)
      water_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: water.id, amount: 0.65)
      evoo_rec = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: evoo.id, amount: 0.05)

      hydro = recipe.water_percentage

      expect(hydro).to eq(65.0)
    end
  end
end
