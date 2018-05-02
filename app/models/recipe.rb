# frozen_string_literal: true

class Recipe < ApplicationRecord
  include RecipeFamilyInfo

  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :tags, through: :recipe_tags
  has_many :recipe_tags, dependent: :destroy
  validates :name, uniqueness: true

  before_destroy :destroy_all_recipe_ingredients

  def self.new_totals(recipe, new_dough_weight)
    ingredients = recipe[:ingredients]
    new_flour_weight = ((new_dough_weight.to_f / recipe[:total_percentage].to_f) * 100).round(2)
    ingredients.each do |name, hash|
      hash[:amount] = new_flour_weight if name == 'flour'
      hash[:amount] = (new_flour_weight * hash[:bakers_percentage].to_f / 100).round(2)
    end
    recipe
  end

  def self.family_group
    grouped = all.group_by(&:family)
    serialized_recipes = {}
    grouped.each do |family, recipes|
      serialized_recipes[family] = recipes.map do |recipe|
        recipe.as_json(
          only: [:name],
          include: { user: { only: %i[name email] } }
        )
      end
    end

    serialized_recipes
  end

  def assign_family
    calculate_family
  end

  def flour_amts
    sum_recipe_ingredient_amounts('flour')
  end

  def total_percent
    recipe_ingredients.reduce(0) { |acc, elem| acc + elem.bakers_percentage }.round(2)
  end

  def ingredient_list
    list = {}
    recipe_ingredients.includes(:ingredient).each do |recipe_ingredient|
      ingredient = ingredients.find(recipe_ingredient.ingredient_id)
      list[ingredient.name] = {
        amount: recipe_ingredient.amount,
        bakers_percentage: recipe_ingredient.bakers_percentage
      }
    end

    list
  end

  private

  def calculate_family
    case
    when lean  then self[:family] = 'Lean'
    when soft  then self[:family] = 'Soft'
    when sweet then self[:family] = 'Sweet'
    when rich  then self[:family] = 'Rich'
    when slack then self[:family] = 'Slack'
    end
  end

  def sum_recipe_ingredient_amounts(category)
    recipe_ingredients.joins(:ingredient)
      .where(ingredients: { category: category })
      .sum(:amount)
  end

  def destroy_all_recipe_ingredients
    recipe_ingredients.delete_all
  end
end
