class ChangeIngredientCategoryColumnToReferenceCategoryModel < ActiveRecord::Migration[5.2]
  def change
    remove_column :ingredients, :category, :string
    add_reference :ingredients, :category, index: true
  end
end
