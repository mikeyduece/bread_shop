# frozen_string_literal: true

class Family < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  has_many :recipes
end
