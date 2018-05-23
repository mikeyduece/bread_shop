# frozen_string_literal: true

class Tag < ApplicationRecord
  validates :name, presence: true
  has_many :recipe_tags, dependent: :destroy
  has_many :recipes, through: :recipe_tags

  def self.create_list(tags)
    tags.map { |tag_name| find_or_create_by(name: tag_name) }
  end
end
