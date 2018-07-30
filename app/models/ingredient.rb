# frozen_string_literal: true

class Ingredient < ApplicationRecord
  include IngredientCategories

  belongs_to :category, optional: true
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients
  validates :name, uniqueness: true

  after_validation :assign_category

  def self.create_list(list)
    list[:ingredients].each { |ing_hash| find_or_create_by(name: ing_hash[:name]) }
  end

  private

  def assign_category
    name = self[:name]
    case
    when SWEETENERS.include?(name) then update_attribute(:category_id, category_assignment('sweetener'))
    when FATS.include?(name)       then update_attribute(:category_id, category_assignment('fat'))
    when FLOURS.include?(name)     then update_attribute(:category_id, category_assignment('flour'))
    when WATER.include?(name)      then update_attribute(:category_id, category_assignment('water'))
    end
  end
end
