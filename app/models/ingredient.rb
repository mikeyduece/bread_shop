# frozen_string_literal: true

class Ingredient < ApplicationRecord
  include IngredientCategories

  belongs_to :category, optional: true
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients
  validates :name, uniqueness: true

  after_validation :assign_category

  def self.create_list(list)
    list.map { |name| Ingredient.find_or_create_by(name: name) }
  end

  private

  def assign_category
    case
    when SWEETENERS.include?(self[:name]) then update_attribute(:category_id, category_assignment('sweetener'))
    when FATS.include?(self[:name])       then update_attribute(:category_id, category_assignment('fat'))
    when FLOURS.include?(self[:name])     then update_attribute(:category_id, category_assignment('flour'))
    when WATER.include?(self[:name])      then update_attribute(:category_id, category_assignment('water'))
    end
  end

  def category_assignment(name)
    Category.find_by(name: name).id
  end
end
