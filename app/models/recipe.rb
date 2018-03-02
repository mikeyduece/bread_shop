class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_ingredients, dependent: :delete_all
  has_many :ingredients, through: :recipe_ingredients
  validates :name, uniqueness: true

  def flour_amts
    flours = %w(semolina durum spelt)
    recipe_ingredients.joins(:ingredient)
      .where('ingredients.name LIKE ? OR
              ingredients.name IN (?) OR
              ingredients.name LIKE ?', '%flour%', flours, '%meal%')
      .sum(:amount)
  end

  def total_percentage
    recipe_ingredients.reduce(0) {|sum, x| sum += x.bakers_percentage}.round(2)
  end

  def sweetener_percentage
    sweets = sweetener_amounts
    calculate_percentage(sweets)
  end

  def fat_percentage
    fats = fat_amounts
    calculate_percentage(fats)
  end

  def water_percentage
    water = water_amt
    calculate_percentage(water)
  end

  def ingredient_list
    list = {}
    recipe_ingredients.includes(:ingredient).each do |recipe_ingredient|
      ingredient = ingredients.find(recipe_ingredient.ingredient_id)
      list[ingredient.name] = {amount: recipe_ingredient.amount,
                               bakers_percentage: recipe_ingredient.bakers_percentage}
    end

    list
  end

  private

  def calculate_percentage(category)
    ((category / flour_amts) * 100).round(2)
  end

  def sweetener_amounts
    sweeteners = %w(sugar honey)
    recipe_ingredients.joins(:ingredient)
      .where('ingredients.name LIKE ? OR
              ingredients.name LIKE ? OR
              ingredients.name LIKE ?',
              '%honey%', '%syrup%', '%sugar%')
      .sum(:amount)
  end

  def fat_amounts
    recipe_ingredients.joins(:ingredient)
      .where(ingredients: { category: 'fat' })
      .sum(:amount)
  end

  def water_amt
    recipe_ingredients.joins(:ingredient)
      .where("ingredients.name='water'")
      .sum(:amount)
  end
end
