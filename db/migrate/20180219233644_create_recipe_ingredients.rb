class CreateRecipeIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :recipe_ingredients do |t|
      t.references :recipe, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.integer :amount

      t.timestamps
    end
  end
end
