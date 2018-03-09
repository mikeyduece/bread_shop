class AddFamilyColumnToRecipes < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :family, :string
  end
end
