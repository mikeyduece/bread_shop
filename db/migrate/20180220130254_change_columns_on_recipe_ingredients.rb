class ChangeColumnsOnRecipeIngredients < ActiveRecord::Migration[5.1]
  def change
    change_column :recipe_ingredients, :amount, :float
    change_column :recipe_ingredients, :bp, :float
  end
end
