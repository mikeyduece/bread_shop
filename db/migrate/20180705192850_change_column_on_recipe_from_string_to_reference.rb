class ChangeColumnOnRecipeFromStringToReference < ActiveRecord::Migration[5.2]
  def change
    remove_column :recipes, :family, :string
    add_column :recipes, :family, :integer, references: :families
  end
end
