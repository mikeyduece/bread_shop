class Ingredient < ApplicationRecord
  include IngredientCategories

  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
  validates :name, uniqueness: true

  before_save :assign_category

  def self.create_list(list)
    list.map { |name| Ingredient.find_or_create_by(name: name) }
  end

  private

  def assign_category
    case
    when SWEETENERS.include?(self[:name]) then self[:category] = 'sweetener'
    when FATS.include?(self[:name])       then self[:category] = 'fat'
    when FLOURS.include?(self[:name])     then self[:category] = 'flour'
    when WATER.include?(self[:name])      then self[:category] = 'water'
    end
  end
end
