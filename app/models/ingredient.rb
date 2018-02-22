class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
  validates :name, uniqueness: true

  def self.create_list(list)
    list.map { |name| Ingredient.find_or_create_by(name: name) }
  end
end
