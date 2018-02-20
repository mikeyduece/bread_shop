class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  validates :amount, presence: true

  def bp
    get_bp
  end

  private

  def get_bp
    flour_amt = recipe.flour_amts
    (amount / flour_amt) * 100
  end
end
