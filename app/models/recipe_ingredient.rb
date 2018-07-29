# frozen_string_literal: true

class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  validates :amount, presence: true,
                     numericality: { greater_than_or_equal_to: 0 }

  def bakers_percentage
    calculate_bakers_percentage
  end

  def self.create_with_list(rec_id, list)
    list[:ingredients].each_with_object({}) do |ing_hash, result|
      amt = ing_hash[:amount].to_f
      ing = Ingredient.find_by(name: ing_hash[:name])
      recipe_ingredient = create(
        recipe_id: rec_id,
        ingredient_id: ing.id,
        amount: amt
      )
      result[ing.name] = {
        amount: amt,
        bakers_percentage: recipe_ingredient.bakers_percentage
      }
    end
  end

  private

  def calculate_bakers_percentage
    flour_amt = recipe.flour_amts
    ((amount / flour_amt) * 100).round(2)
  end
end
