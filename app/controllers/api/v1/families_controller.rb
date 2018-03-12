class Api::V1::FamiliesController < Api::V1::ApplicationController

  def index
    families = Recipe.family_group
    render json: families
  end

  def show
    require 'pry'; binding.pry
  end
end
