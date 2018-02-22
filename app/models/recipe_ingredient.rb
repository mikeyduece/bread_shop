class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  validates :amount, presence: true

  def bp
    get_bp
  end

  def self.create_with_list(rec_id, list)
    saved = {}
    list.each do |name, value|
      ing = Ingredient.find_by_name(name)
      x = RecipeIngredient.create(recipe_id: rec_id,
                              ingredient_id: ing.id,
                              amount: value[:amount].to_f)
      saved[name] = {amount: value[:amount].to_f,
                     bp: x.bp}
    end
    saved
  end

  private

  def get_bp
    flour_amt = recipe.flour_amts
    ((amount / flour_amt) * 100).round(2)
  end
end
