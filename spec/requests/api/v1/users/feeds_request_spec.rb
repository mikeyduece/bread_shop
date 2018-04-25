# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feeds' do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:token) { TokiToki.encode(user.attributes) }

  it 'does a thing' do
    VCR.use_cassette('feeds') do
      get "/api/v1/users/#{user.email}/feeds/me", params: { token: token }

      expect(response).to be_success

      activity = JSON.parse(response.body, symbolize_names: true)

      expect(activity.first[:actor][:name]).to eq(user.name)
    end
  end

  it 'does another thing' do
    VCR.use_cassette('flat_feeds') do
      post "/api/v1/users/#{user.email}/follow/#{user2.email}", params: { token: token }

      get "/api/v1/users/#{user2.email}/feeds/notification", params: { token: token }

      expect(response).to be_success

      activity = JSON.parse(response.body, symbolize_names: true)

      require 'pry'; binding.pry
      expect(activity.first[:actor][:name]).to eq(user.name)
    end
  end
end
