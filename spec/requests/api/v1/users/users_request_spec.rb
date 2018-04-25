# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Requests' do
  let!(:users) { create_list(:user, 10) }
  # TODO: Make this to where only an admin can see this list?
  it '#GET all users' do
    get '/api/v1/users/all'

    expect(response).to be_success

    user_list = JSON.parse(response.body, symbolize_names: true)

    expect(user_list.count).to eq(10)
    expect(response.status).to eq(200)
  end
end
