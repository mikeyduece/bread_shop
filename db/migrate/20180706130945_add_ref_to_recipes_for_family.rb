class AddRefToRecipesForFamily < ActiveRecord::Migration[5.2]
  def change
    add_reference :recipes, :family, foreign_key: true
  end
end
