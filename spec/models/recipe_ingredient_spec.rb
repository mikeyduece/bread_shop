require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  it { should validate_presence_of :amount }
  it { should validate_numericality_of :amount }
  it { should_not allow_value(-1).for(:amount) }
  it { should allow_value(0).for(:amount) }

  context 'Instance Methods' do
    it '#bp' do
      user = create(:user)
      recipe = create(:recipe, user: user)
      ing_list = create_list(:ingredient, 6)
      flour1 = create(:ingredient, name: 'ap flour', category: 'flour')
      flour2 = create(:ingredient, name: 'bread flour', category: 'flour')
      rec_ing1 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour1.id, amount: 100)
      rec_ing2 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour2.id, amount: 300)
      rec_ing3 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[0].id, amount: 50)
      rec_ing4 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[1].id, amount: 20)
      rec_ing5 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[2].id, amount: 10)
      rec_ing6 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[3].id, amount: 25)
      rec_ing7 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[4].id, amount: 30)
      rec_ing8 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[5].id, amount: 20)

      expect(rec_ing1.bakers_percentage).to eq(25.0)
      expect(rec_ing2.bakers_percentage).to eq(75.0)
      expect(rec_ing3.bakers_percentage).to eq(12.5)
      expect(rec_ing4.bakers_percentage).to eq(5.0)
      expect(rec_ing5.bakers_percentage).to eq(2.5)
      expect(rec_ing6.bakers_percentage).to eq(6.25)
      expect(rec_ing7.bakers_percentage).to eq(7.5)
      expect(rec_ing8.bakers_percentage).to eq(5.0)
    end
  end
end
