# frozen_string_literal: true

class Api::V1::RecipeSerializer < ActiveModel::Serializer
  attributes :id, :name, :tags, :total_percent, :ingredient_list, :family
  belongs_to :user
  belongs_to :family
  has_many :recipe_ingredients

  def family
    object.family.name
  end

  def recipe_ingredients
    object.ingredient_list
  end

  def tags
    object.tags.map do |tag|
      ::Api::V1::TagSerializer.new(tag).attributes
    end
  end

  def total_percent
    object.total_percent
  end

  def ingredient_list
    object.ingredient_list
  end
end
