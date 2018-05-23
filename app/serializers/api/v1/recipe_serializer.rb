# frozen_string_literal: true

class Api::V1::RecipeSerializer < ActiveModel::Serializer
  attributes :name, :family
  belongs_to :user
  has_many :tags
end
