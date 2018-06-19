#frozen_string_literal: true
require 'json'

class NutritionLabelService
  def initialize(recipe)
    @recipe = recipe
    @conn = Faraday.new(url: "https://api.edamam.com/api/nutrition-details") do |faraday|
      faraday.params["app_id"] = "#{ENV['label_app_id']}"
      faraday.params["app_key"] = "#{ENV['label_app_key']}"
      faraday.adapter Faraday.default_adapter
    end
  end

  def post_url
    response = @conn.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        'title': recipe[:title],
        'ingr': recipe[:ingr]
      }.to_json
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.analyze_recipe(recipe)
    new(recipe).post_url
  end

  def self.recipe_formatter(recipe)
    require 'pry'; binding.pry
  end

  private
    attr_reader :recipe
end
