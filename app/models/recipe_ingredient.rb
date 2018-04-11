class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  validates :amount, presence: true,
                     numericality: { greater_than_or_equal_to: 0 }

  def bakers_percentage
    calculate_bakers_percentage
  end

  def self.create_with_list(rec_id, list)
    saved = {}
    list.each do |name, value|
      ing = Ingredient.find_by(name: name)
      x = RecipeIngredient.create(
        recipe_id: rec_id, ingredient_id: ing.id,
        amount: value[:amount].to_f
      )
      saved[name] = {
        amount: value[:amount].to_f,
        bakers_percentage: x.bakers_percentage
      }
    end
    saved
  end

  private

  def calculate_bakers_percentage
    flour_amt = recipe.flour_amts
    ((amount / flour_amt) * 100).round(2)
  end
end
