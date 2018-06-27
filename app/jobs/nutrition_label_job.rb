# frozen_string_literal: true

class NutritionLabelJob < ApplicationJob
  queue_as :default

  def perform(*args)
    return unless Recipe.any?

    unanalyzed_recipes = Recipe.where(label: nil)
    unanalyzed_recipes.each(&:fetch_label_info)
  end
end
