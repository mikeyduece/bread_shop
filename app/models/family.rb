# frozen_string_literal: true

class Family < ApplicationRecord
  validates :name, presence: true
  has_many :recipes
end
