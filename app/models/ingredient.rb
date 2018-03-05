class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
  validates :name, uniqueness: true

  before_save :assign_category

  def self.create_list(list)
    list.map { |name| Ingredient.find_or_create_by(name: name) }
  end

  def assign_category
    if sweeteners.include?(self[:name])
      self[:category] = 'sweetener'
    elsif fats.include?(self[:name])
      self[:category] = "fat"
    elsif water.include?(self[:name])
      self[:category] = 'water'
    elsif flours.include?(self[:name])
      self[:category] = 'flour'
    end
  end

  private

  def sweeteners
    ['sugar', 'brown sugar', 'corn syrup', 'agave', 'molasses',
     'honey', 'maple syrup']
  end

  def fats
    ['butter', 'milk', 'cream', 'sour cream', 'canola oil',
     'olive oil', 'margerine']
  end

  def water
    ['water']
  end

  def flours
    ['flour', 'bread flour', 'high gluten flour', 'ap flour',
     'all purpose flour', 'spelt', 'wheat flour', 'whole wheat flour',
     'cake flour', 'pastry flour', 'semolina', 'durum', 'corn meal', 'flax meal']
  end
end
