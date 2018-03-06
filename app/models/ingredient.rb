class Ingredient < ApplicationRecord
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
    when sweeteners.include?(self[:name]) then self[:category] = "sweetener"
    when fats.include?(self[:name]) then self[:category] = "fat"
    when flours.include?(self[:name]) then self[:category] = "flour"
    when water.include?(self[:name]) then self[:category] = "water"
    end
  end

  def sweeteners
    %w(sugar brown\ sugar corn\ syrup agave molasses honey maple\ syrup)
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
