require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  it {should validate_presence_of :amount}
  context 'Instance Methods' do
    it '#bp' do
      user = create(:user)
      recipe = create(:recipe)
      ing_list = create_list(:ingredient, 6)
      flour_1 = create(:ingredient, name: 'ap flour')
      flour_2 = create(:ingredient, name: 'bread flour')
      rec_ing_1 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour_1.id, amount: 100)
      rec_ing_2 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: flour_2.id, amount: 300)
      rec_ing_3 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[0].id, amount: 50)
      rec_ing_4 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[1].id, amount: 20)
      rec_ing_5 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[2].id, amount: 10)
      rec_ing_6 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[3].id, amount: 25)
      rec_ing_7 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[4].id, amount: 30)
      rec_ing_8 = RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ing_list[5].id, amount: 20)

      expect(rec_ing_1.bp).to eq(25.0)
      expect(rec_ing_2.bp).to eq(75.0)
      expect(rec_ing_3.bp).to eq(12.5)
      expect(rec_ing_4.bp).to eq(5.0)
      expect(rec_ing_5.bp).to eq(2.5)
      expect(rec_ing_6.bp).to eq(6.25)
      expect(rec_ing_7.bp).to eq(7.5)
      expect(rec_ing_8.bp).to eq(5.0)
    end
  end
end
