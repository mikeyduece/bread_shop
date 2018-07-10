# frozen_string_literal: true

class Api::V1::RecipeSerializer < ActiveModel::Serializer
  attributes :name
  belongs_to :user
  belongs_to :family
  has_many :tags
end
