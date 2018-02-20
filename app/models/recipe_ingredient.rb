class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  validates :amount, presence: true

  after_validation :get_bp

  def get_bp
    flour_amt = recipe.flour_amts
    self.bp = (amount / flour_amt) * 100
  end
end
