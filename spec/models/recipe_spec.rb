require 'rails_helper'

RSpec.describe Recipe, 'validations' do
  it { should validate_uniqueness_of :name }
  it { should validate_presence_of :name }
end

RSpec.describe Recipe, 'associations' do
  it { should have_many(:recipe_ingredients).dependent(:destroy) }
  it { should have_many(:ingredients).through(:recipe_ingredients) }
  it { should belong_to(:user) }
  it { should have_many(:tags).through(:recipe_tags) }
  it { should have_many(:recipe_tags).dependent(:destroy) }
  it { should have_many(:likes).dependent(:destroy) }
  it { should belong_to(:family) }
end

RSpec.describe Recipe, type: :model do
  let(:user) { create(:user_with_recipes) }
  let(:recipe) { user.recipes[0] }

  context 'Instance Methods' do
    it '#flour_amts' do
      recipe = create(:recipe)
      recipe.recipe_ingredients.clear
      flour1 = create(:ingredient, name: 'ap flour', category: 'flour')
      flour2 = create(:ingredient, name: 'bread flour', category: 'flour')
      ingredient = create(:ingredient, name: 'sugar', category: 'sweetener')
      rec_ing1 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour1.id, amount: 100.00)
      rec_ing2 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour2.id, amount: 300.00)
      ing = create(:recipe_ingredient, ingredient: ingredient, recipe: recipe)
      recipe.recipe_ingredients = [rec_ing1, rec_ing2, ing]

      flour = recipe.flour_amts
      expect(flour).to eq(400.00)
    end

    it 'can calculate more than one type of flour' do
      recipe = create(:recipe)
      recipe.recipe_ingredients.clear
      flour1 = create(:ingredient, name: 'ap flour', category: 'flour')
      flour2 = create(:ingredient, name: 'cornmeal', category: 'flour')
      flour3 = create(:ingredient, name: 'flax meal', category: 'flour')
      flour4 = create(:ingredient, name: 'semolina', category: 'flour')
      flour5 = create(:ingredient, name: 'durum', category: 'flour')
      flour6 = create(:ingredient, name: 'spelt', category: 'flour')
      ingredient = create(:ingredient, name: 'sugar', category: 'sweetener')
      rec_ing1 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour1.id, amount: 1.00)
      rec_ing2 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour2.id, amount: 3.00)
      rec_ing3 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour3.id, amount: 3.00)
      rec_ing4 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour4.id, amount: 3.00)
      rec_ing5 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour5.id, amount: 3.00)
      rec_ing6 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour6.id, amount: 3.00)
      ing = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ingredient.id, amount: 10.00)
      recipe.recipe_ingredients = [rec_ing1, rec_ing2, ing, rec_ing4, rec_ing3, rec_ing5, rec_ing6]

      flour = recipe.flour_amts

      expect(flour).to eq(16.0)
    end

    it '#total_percentage' do
      recipe = create(:recipe)
      recipe.recipe_ingredients.clear
      ing_list = []
      ingredient_categories = %w[sweetener fat water]
      6.times do
        ing_list << create(:ingredient, category: ingredient_categories.sample)
      end
      flour1 = create(:ingredient, name: 'AP flour', category: 'flour')
      flour2 = create(:ingredient, name: 'Bread flour', category: 'flour')
      rec_ing1 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour1.id, amount: 100)
      rec_ing2 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour2.id, amount: 300)
      rec_ing3 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[0].id, amount: 50)
      rec_ing4 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[1].id, amount: 20)
      rec_ing5 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[2].id, amount: 10)
      rec_ing6 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[3].id, amount: 25)
      rec_ing7 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[4].id, amount: 30)
      rec_ing8 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[5].id, amount: 20)
      recipe.recipe_ingredients = [rec_ing1, rec_ing2, rec_ing3, rec_ing4, rec_ing5, rec_ing6, rec_ing7, rec_ing8]

      total = recipe.total_percent

      expect(total).to eq(138.75)
    end

    it 'can have a different #total_percentage' do
      recipe = create(:recipe)
      recipe.recipe_ingredients.clear
      ing_list = []
      ingredient_categories = %w[sweetener fat water]
      6.times do
        ing_list << create(:ingredient, category: ingredient_categories.sample)
      end
      flour1 = create(:ingredient, name: 'AP flour', category: 'flour')
      flour2 = create(:ingredient, name: 'Bread flour', category: 'sweetener')
      rec_ing1 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour1.id, amount: 200)
      rec_ing2 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour2.id, amount: 300)
      rec_ing3 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[0].id, amount: 100.63)
      rec_ing4 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[1].id, amount: 20)
      rec_ing5 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[2].id, amount: 10)
      rec_ing6 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[3].id, amount: 25)
      rec_ing7 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[4].id, amount: 30)
      rec_ing8 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[5].id, amount: 20)
      recipe.recipe_ingredients = [rec_ing1, rec_ing2, rec_ing3, rec_ing4, rec_ing5, rec_ing6, rec_ing7, rec_ing8]

      total = recipe.total_percent

      expect(total).to eq(352.82)
    end

    it '#sweetener_percentage' do
      recipe.recipe_ingredients.clear
      water = Ingredient.create!(name: 'water', category: 'water')
      yeast = Ingredient.create!(name: 'cake yeast', category: 'yeast')
      milk = Ingredient.create!(name: 'milk', category: 'fat')
      butter = Ingredient.create!(name: 'butter', category: 'fat')
      sugar = Ingredient.create!(name: 'sugar', category: 'sweetener')
      flour = Ingredient.create!(name: 'flour', category: 'flour')
      salt = Ingredient.create!(name: 'salt', category: 'salt')
      RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: water.id, amount: 0.7)
      RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: yeast.id, amount: 0.04)
      RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: milk.id, amount: 0.35)
      RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: butter.id, amount: 0.12)
      RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: sugar.id, amount: 0.06)
      RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: flour.id, amount: 1.75)
      RecipeIngredient.create!(recipe_id: recipe.id, ingredient_id: salt.id, amount: 0.035)

      sweets = recipe.sweetener_percentage

      expect(sweets).to eq(3.43)
    end

    it 'can calculate percentage with more than one sweetener' do
      recipe.recipe_ingredients.clear
      bf = Ingredient.create(name: 'bread flour', category: 'flour')
      ww = Ingredient.create(name: 'whole wheat flour', category: 'flour')
      sugar = Ingredient.create(name: 'sugar', category: 'sweetener')
      bs = Ingredient.create(name: 'brown sugar', category: 'sweetener')
      honey = Ingredient.create(name: 'honey', category: 'sweetener')
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bf.id, amount: 0.50)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ww.id, amount: 0.50)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: sugar.id, amount: 0.25)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bs.id, amount: 0.10)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: honey.id, amount: 0.05)

      sweets = recipe.sweetener_percentage

      expect(sweets).to eq(40.0)
    end

    it 'can pick out sweeteners with syrup in name' do
      recipe.recipe_ingredients.clear
      bf = Ingredient.create(name: 'bread flour', category: 'flour')
      cornsyrup = Ingredient.create(name: 'corn syrup', category: 'sweetener')
      sugar = Ingredient.create(name: 'sugar', category: 'sweetener')
      bs = Ingredient.create(name: 'brown sugar', category: 'sweetener')
      honey = Ingredient.create(name: 'honey', category: 'sweetener')
      agave = Ingredient.create(name: 'agave syrup', category: 'sweetener')
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bf.id, amount: 2.0)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: cornsyrup.id, amount: 0.50)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: sugar.id, amount: 0.25)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bs.id, amount: 0.10)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: honey.id, amount: 0.05)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: agave.id, amount: 0.05)

      sweets = recipe.sweetener_percentage

      expect(sweets).to eq(47.5)
    end

    it '#fat_percentage' do
      recipe.recipe_ingredients.clear
      bf = Ingredient.create(name: 'bread flour', category: 'flour')
      butter = Ingredient.create(name: 'butter', category: 'fat')
      sugar = Ingredient.create(name: 'sugar', category: 'sweetener')
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bf.id, amount: 1.0)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: butter.id, amount: 0.25)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: sugar.id, amount: 0.05)

      fat = recipe.fat_percentage

      expect(fat).to eq(25.0)
    end

    it '#fat_percentage can calculate with more than one fat' do
      recipe.recipe_ingredients.clear
      bf = Ingredient.create(name: 'bread flour', category: 'flour')
      butter = Ingredient.create(name: 'butter', category: 'fat')
      sc = Ingredient.create(name: 'sour cream', category: 'fat')
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bf.id, amount: 1.0)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: butter.id, amount: 0.25)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: sc.id, amount: 0.05)

      fat = recipe.fat_percentage

      expect(fat).to eq(30.0)
      expect(fat).not_to eq(130.0)
    end

    it '#fat_percentage can find oils as well' do
      recipe = user.recipes[0]
      recipe.recipe_ingredients.clear
      bf = Ingredient.create(name: 'bread flour', category: 'flour')
      canola = Ingredient.create(name: 'canola oil', category: 'fat')
      evoo = Ingredient.create(name: 'olive oil', category: 'fat')
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bf.id, amount: 1.0)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: canola.id, amount: 0.25)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: evoo.id, amount: 0.05)

      fat = recipe.fat_percentage

      expect(fat).to eq(30.0)
      expect(fat).not_to eq(130.0)
    end

    it '#water_percentage' do
      recipe = user.recipes[0]
      recipe.recipe_ingredients.clear
      bf = Ingredient.create(name: 'bread flour', category: 'flour')
      water = Ingredient.create(name: 'water', category: 'water')
      evoo = Ingredient.create(name: 'olive oil', category: 'fat')
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bf.id, amount: 1.0)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: water.id, amount: 0.65)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: evoo.id, amount: 0.05)

      hydro = recipe.water_percentage

      expect(hydro).to eq(65.0)
    end

    it '#assign_family as Lean' do
      user = create(:user)
      recipe = Recipe.create(name: 'Baguette', user_id: user.id)
      flour = Ingredient.create(name: 'flour', category: 'flour')
      water = Ingredient.create(name: 'water', category: 'water')
      salt = Ingredient.create(name: 'salt')
      yeast = Ingredient.create(name: 'yeast')
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour.id, amount: 1.0)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: water.id, amount: 0.63)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: salt.id, amount: 0.02)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: yeast.id, amount: 0.03)
      recipe.assign_family

      expect(recipe.family.name).to eq('Lean')
      expect(recipe.family.name).not_to eq('Soft')
      expect(recipe.family.name).not_to eq('Rich')
      expect(recipe.family.name).not_to eq('Slack')
      expect(recipe.family.name).not_to eq('Sweet')
    end

    it '#assign_family as Soft' do
      user = create(:user)
      recipe.recipe_ingredients.clear
      recipe = Recipe.create(name: 'Ballons', user_id: user.id)
      recipe.recipe_ingredients.clear
      flour = Ingredient.create(name: 'flour', category: 'flour')
      water = Ingredient.create(name: 'water', category: 'water')
      milk = Ingredient.create(name: 'milk')
      butter = Ingredient.create(name: 'butter', category: 'fat')
      sugar = Ingredient.create(name: 'sugar', category: 'sweetener')
      salt = Ingredient.create(name: 'salt')
      yeast = Ingredient.create(name: 'yeast')
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour.id, amount: 1.75)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: water.id, amount: 0.70)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: salt.id, amount: 0.035)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: yeast.id, amount: 0.04)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: milk.id, amount: 0.35)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: butter.id, amount: 0.12)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: sugar.id, amount: 0.088)
      recipe.assign_family

      expect(recipe.family.name).to eq('Soft')
      expect(recipe.family.name).not_to eq('Lean')
      expect(recipe.family.name).not_to eq('Rich')
      expect(recipe.family.name).not_to eq('Slack')
      expect(recipe.family.name).not_to eq('Sweet')
    end

    it '#assign_family as Rich' do
      recipe.recipe_ingredients.clear
      flour = Ingredient.create(name: 'flour', category: 'flour')
      eggs = Ingredient.create(name: 'eggs')
      milk = Ingredient.create(name: 'milk')
      butter = Ingredient.create(name: 'butter', category: 'fat')
      salt = Ingredient.create(name: 'salt')
      yeast = Ingredient.create(name: 'yeast')
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour.id, amount: 1.31)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: eggs.id, amount: 0.10)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: salt.id, amount: 0.025)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: yeast.id, amount: 0.06)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: milk.id, amount: 0.81)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: butter.id, amount: 0.28)
      recipe.assign_family

      expect(recipe.family.name).to eq('Rich')
      expect(recipe.family.name).not_to eq('Lean')
      expect(recipe.family.name).not_to eq('Soft')
      expect(recipe.family.name).not_to eq('Slack')
      expect(recipe.family.name).not_to eq('Sweet')
    end

    it '#assign_family as Slack' do
      recipe.recipe_ingredients.clear
      flour1 = Ingredient.create(name: 'flour I', category: 'flour')
      flour2 = Ingredient.create(name: 'flour II', category: 'flour')
      water = Ingredient.create(name: 'water', category: 'water')
      evoo = Ingredient.create(name: 'olive oil', category: 'fat')
      sugar = Ingredient.create(name: 'sugar', category: 'sweetener')
      salt = Ingredient.create(name: 'salt')
      yeast = Ingredient.create(name: 'yeast')
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour1.id, amount: 0.67)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour2.id, amount: 1.00)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: water.id, amount: 1.12)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: salt.id, amount: 0.04)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: yeast.id, amount: 0.05)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: sugar.id, amount: 0.10)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: evoo.id, amount: 0.09)
      recipe.assign_family

      expect(recipe.family.name).to eq('Slack')
      expect(recipe.family.name).not_to eq('Lean')
      expect(recipe.family.name).not_to eq('Rich')
      expect(recipe.family.name).not_to eq('Soft')
      expect(recipe.family.name).not_to eq('Sweet')
    end

    it '#assign_family as Sweet' do
      recipe.recipe_ingredients.clear
      bread_flour = Ingredient.create(name: 'bread flour', category: 'flour')
      cake_flour = Ingredient.create(name: 'cake flour', category: 'flour')
      eggs  = Ingredient.create(name: 'eggs')
      milk  = Ingredient.create(name: 'milk')
      butter = Ingredient.create(name: 'butter', category: 'fat')
      salt = Ingredient.create(name: 'salt')
      yeast = Ingredient.create(name: 'yeast')
      sugar = Ingredient.create(name: 'sugar', category: 'sweetener')
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: bread_flour.id, amount: 0.65)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: cake_flour.id, amount: 0.80)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: eggs.id, amount: 0.22)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: salt.id, amount: 0.03)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: yeast.id, amount: 0.12)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: milk.id, amount: 0.63)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: butter.id, amount: 0.30)
      RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: sugar.id, amount: 0.30)
      recipe.assign_family

      expect(recipe.family.name).to eq('Sweet')
      expect(recipe.family.name).not_to eq('Lean')
      expect(recipe.family.name).not_to eq('Soft')
      expect(recipe.family.name).not_to eq('Slack')
      expect(recipe.family.name).not_to eq('Rich')
    end
  end
end
