# frozen_string_literal: true

class Api::V1::NewTotalsController < Api::V1::ApplicationController
  def show
    recipe = Recipe.new_totals(new_total_params)
    render(json: recipe)
  end

  def new_total_params
    params.require(:recipe)
      .permit(
        :new_dough_weight,
        original: [
          :id, :name, :tags, :total_percent,
          :family, :created_at, ingredient_list: {}
        ]
      ).to_h.deep_symbolize_keys
  end
end
