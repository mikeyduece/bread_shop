class AddNutritionLabelColumnToRecipe < ActiveRecord::Migration[5.2]
  enable_extension 'hstore' unless extension_enabled?('hstore')
  def change
    add_column :recipes, :label, :hstore
  end
end
