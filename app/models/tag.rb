class Tag < ApplicationRecord
  validates :name, presence: true
  has_many :recipe_tags
  has_many :recipes, through: :recipe_tags
end
