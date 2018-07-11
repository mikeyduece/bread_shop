# frozen_string_literal: true

class Api::V1::RecipeSerializer < ActiveModel::Serializer
  attributes :id, :name
  belongs_to :user
  belongs_to :family
  has_many :tags
  has_many :recipe_ingredients

  def recipe_ingredients
    object.ingredient_list
  end

  # def tags
  #   object.tags.map do |tag|
  #     ::Api::V1::TagSerializer.new(tag).name
  #   end
  # end
end
