# frozen_string_literal: true

class Api::V1::FamiliesController < Api::V1::ApplicationController
  def show
    family = Family.find_by(name: family_params)
    render(json: family, each_serializer: Api::V1::FamilySerializer)
  end

  private

  def family_params
    params.require(:family_name)
  end
end
