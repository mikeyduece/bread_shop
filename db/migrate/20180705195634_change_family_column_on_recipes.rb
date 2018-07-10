class ChangeFamilyColumnOnRecipes < ActiveRecord::Migration[5.2]
  def change
    rename_column :recipes, :family, :family_id
  end
end
