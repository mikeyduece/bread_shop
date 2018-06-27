# frozen_string_literal: true
require 'json'

class Recipe < ApplicationRecord
  include RecipeFamilyInfo

  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags
  has_many :likes, dependent: :destroy
  validates :name, uniqueness: true, presence: true

  before_destroy :destroy_all_recipe_ingredients

  def fetch_label_info
    self.label = NutritionLabelService.analyze_recipe(self)
  end

  def tag_list
    tags.pluck(:name)
  end

  def recipe_formatter
    {
      'title': name,
      'ingr': recipe_ingredients.map do |recipe_ingredient|
        "#{recipe_ingredient.amount}oz #{recipe_ingredient.ingredient.name}"
      end
    }.to_json
  end

  def self.new_totals(recipe, new_dough_weight)
    ingredients_hash = recipe[:ingredients]
    new_flour_weight = new_flour_total(recipe, new_dough_weight)
    recalculated_amounts(ingredients_hash, new_flour_weight)
    recipe
  end

  def self.family_group
    grouped = all.group_by(&:family)
    serialized_recipes = {}
    grouped.each do |family, recipes|
      serialized_recipes[family] = serialized_families(recipes)
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
  class << self
    def serialized_families(recipes)
      recipes.map do |recipe|
        recipe.as_json(
          only: [:name],
          include: { user: { only: %i[name email] } }
        )
      end
    end

    def new_flour_total(recipe, new_dough_weight)
      ((new_dough_weight.to_f / recipe[:total_percentage].to_f) * 100).round(2)
    end

    def recalculated_amounts(ingredients_hash, new_flour_weight)
      ingredients_hash.each do |name, hash|
        hash[:amount] = new_flour_weight if name == 'flour'
        hash[:amount] = (new_flour_weight * hash[:bakers_percentage].to_f / 100).round(2)
      end
    end
  end

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
