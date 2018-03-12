class Api::V1::FamiliesController < Api::V1::ApplicationController

  def index
    Recipe.family_group
  end

  def show
    require 'pry'; binding.pry
  end
end
