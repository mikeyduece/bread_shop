class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
  validates :name, uniqueness: true

  before_save :assign_category

  SWEETENERS = %w[
    sugar brown\ sugar corn\ syrup
    agave molasses honey maple\ syrup stevia
  ].freeze
  FATS = %w[butter cream sour\ cream canola\ oil olive\ oil margerine].freeze
  WATER = %w[water milk].freeze
  FLOURS = %w[
    flour bread\ flour high\ gluten\ flour ap\ flour all\ purpose\ flour
    spelt wheat\ flour whole\ wheat\ flour cake\ flour pastry\ flour semolina
    durum corn\ meal flax\ meal
  ].freeze


  def self.create_list(list)
    list.map { |name| Ingredient.find_or_create_by(name: name) }
  end

  private

  def assign_category
    case
    when SWEETENERS.include?(self[:name]) then self[:category] = 'sweetener'
    when FATS.include?(self[:name])       then self[:category] = 'fat'
    when FLOURS.include?(self[:name])     then self[:category] = 'flour'
    when WATER.include?(self[:name])      then self[:category] = 'water'
    end
  end
end
