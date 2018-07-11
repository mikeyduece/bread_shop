# frozen_string_literal: true

class Api::V1::FamiliesController < Api::V1::ApplicationController
  def show
    family = Family.find_by(name: params[:family_name])
    render(json: family, each_serializer: Api::V1::FamilySerializer)
  end
end
