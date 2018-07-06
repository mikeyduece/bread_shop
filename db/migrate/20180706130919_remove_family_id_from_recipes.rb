class RemoveFamilyIdFromRecipes < ActiveRecord::Migration[5.2]
  def change
    remove_column :recipes, :family_id, :integer
  end
end
