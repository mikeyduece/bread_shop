class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  validates :name, uniqueness: true

  before_destroy :destroy_all_recipe_ingredients

  def self.family_group
    grouped = all.group_by(&:family)
    serialized_recipes = {}
    grouped.each do |family, recipes|
      serialized_recipes[family] = recipes.map do |recipe|
        recipe.as_json(only: [:name],
                       include: { user: { only: [:name, :email] } })
      end
    end

    serialized_recipes
  end

  def assign_family
    calculate_family
  end

  def flour_amts
    recipe_ingredients.joins(:ingredient)
      .where(ingredients: { category: 'flour' })
      .sum(:amount)
  end

  def total_percent
    recipe_ingredients.reduce(0) { |sum, x| sum + x.bakers_percentage }.round(2)
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

  def lean
    return true if sweet_and_fat_amts.all? { |amt| low.include?(amt) }
  end

  def soft
    if (water_percentage + fat_percentage) < 70.0 &&
        moderate.include?(sweetener_percentage) &&
        moderate.include?(fat_percentage)
      return true
    end
  end

  def rich
    if (moderate.include?(sweetener_percentage) &&
        high.include?(fat_percentage)) ||
        high.include?(fat_percentage)
      return true
    end
  end

  def slack
    return true if water_percentage + fat_percentage > 70.0
  end

  def sweet
    return true if sweet_and_fat_amts.all? { |amt| high.include?(amt) }
  end

  def low
    (0.0..4.99)
  end

  def moderate
    (5.0..10.0)
  end

  def high
    (11.0..25.0)
  end

  def sweet_and_fat_amts
    [sweetener_percentage, fat_percentage]
  end

  def calculate_percentage(category)
    ((category / flour_amts) * 100).round(2)
  end

  def sweetener_amounts
    recipe_ingredients.joins(:ingredient)
      .where(ingredients: { category: 'sweetener' })
      .sum(:amount)
  end

  def fat_amounts
    recipe_ingredients.joins(:ingredient)
      .where(ingredients: { category: 'fat' })
      .sum(:amount)
  end

  def water_amt
    recipe_ingredients.joins(:ingredient)
      .where(ingredients: { category: 'water' })
      .sum(:amount)
  end

  def destroy_all_recipe_ingredients
    recipe_ingredients.delete_all
  end
end
