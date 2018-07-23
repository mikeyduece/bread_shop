# frozen_string_literal: true

class Api::V1::RecipeSerializer < ActiveModel::Serializer
  attributes :id, :name, :tags, :total_percent, :ingredient_list, :family,
    :created_at
  belongs_to :user
  belongs_to :family

  def created_at
    created = object.created_at
    created.strftime("Created on %d %^b '%y at %H:%M")
  end

  def family
    object.family.name
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
