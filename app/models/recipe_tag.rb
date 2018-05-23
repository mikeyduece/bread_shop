class RecipeTag < ApplicationRecord
  belongs_to :recipe
  belongs_to :tag

  def self.create_list(recipe, tag_list)
    recipe.tags << tag_list
  end
end
