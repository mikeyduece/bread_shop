# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feeds' do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:token) { TokiToki.encode(user.attributes) }
  let!(:token2) { TokiToki.encode(user2.attributes) }

 # it 'feeds#user' do
 #   VCR.use_cassette('feeds') do
 #     get "/api/v1/users/#{user.email}/feeds/me", params: { token: token }

 #     expect(response).to be_successful

 #     activity = JSON.parse(response.body, symbolize_names: true)

 #     expect(activity.first[:actor][:name]).to eq(user.name)
 #   end
 # end

  it 'feeds#notification' do
    VCR.use_cassette('notification_feeds') do
      post "/api/v1/users/#{user.id}/follow/#{user2.id}", params: { token: token }

      get "/api/v1/users/#{user2.id}/feeds/notification", params: { token: token2 }

      expect(response).to be_successful

      activity = JSON.parse(response.body, symbolize_names: true)

      expect(activity[0][:activities][0][:actor][:name]).to eq(user.name)
      expect(activity[0][:activities][0][:object][:name]).to eq(user2.name)
      expect(activity[0][:activities][0][:verb]).to eq('Follow')
    end
  end

  it 'feeds#flat' do
    VCR.use_cassette('flat_feeds') do
      list = {
        name: 'baguette',
        ingredients: [
          { name: 'flour', amount: 1.00 },
          { name: 'water', amount: 0.62 },
          { name: 'yeast', amount: 0.02 },
          { name: 'salt', amount: 0.02 }
        ]
      }
      post "/api/v1/users/#{user.id}/follow/#{user2.id}", params: { token: token }
      post "/api/v1/users/#{user2.id}/recipes", params: { token: token2, recipe: list }

      get "/api/v1/users/#{user.id}/feeds/flat", params: { token: token }

      expect(response).to be_successful

      activity = JSON.parse(response.body, symbolize_names: true)

      expect(activity.empty?).not_to be true
    end
  end
end
