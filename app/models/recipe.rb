class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  validates :name, uniqueness: true

  def flour_amts
    recipe_ingredients.select('ingredients.name')
      .joins(:ingredient)
      .where(recipe_id: self.id)
      .where('ingredients.name like ?', '%Flour%')
      .sum(:amount)
  end

  def total_percentage
    recipe_ingredients.reduce(0) {|sum, x| sum += x.bp}
  end
end
