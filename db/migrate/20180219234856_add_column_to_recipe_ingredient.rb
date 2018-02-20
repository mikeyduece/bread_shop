class AddColumnToRecipeIngredient < ActiveRecord::Migration[5.1]
  def change
    add_column :recipe_ingredients, :bp, :integer
  end
end
