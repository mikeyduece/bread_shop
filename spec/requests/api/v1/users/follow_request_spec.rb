# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Follow Requests' do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:token1) { TokiToki.encode(user1.attributes) }

  it 'can follow a user' do
    VCR.use_cassette('follow') do
      post "/api/v1/users/#{user1.id}/follow/#{user2.id}",
        params: { token: token1 }

      expect(response).to be_successful
      expect(response.body).to eq('Followed!')
      expect(user1.follows[0].target_id).to eq(user2.id)
      expect(user2.followed_by(user1)).to be true
    end
  end

  it 'can follow more than one user' do
    VCR.use_cassette('follow_more') do
      post "/api/v1/users/#{user1.id}/follow/#{user2.id}",
      params: { token: token1 }
      post "/api/v1/users/#{user1.id}/follow/#{user3.id}",
        params: { token: token1 }

      expect(response).to be_successful
      expect(response.body).to eq('Followed!')
      expect(user1.follows.count).to eq(2)
      expect(user1.follows.first.target_id).to eq(user2.id)
      expect(user1.follows.last.target_id).to eq(user3.id)
      expect(user2.followed_by(user1)).to be true
      expect(user3.followed_by(user1)).to be true
      expect(user3.followed_by(user2)).not_to be true
      expect(user2.followed_by(user3)).not_to be true
    end
  end

  it 'can unfollow a user' do
    VCR.use_cassette('unfollow') do
      follow1 = create(:follow, target_id: user2.id)
      follow2 = create(:follow, target_id: user3.id)
      user1.follows << [follow1, follow2]

      expect(user1.follows.count).to eq(2)
      expect(user1.follows.first.target_id).to eq(user2.id)

      delete "/api/v1/users/#{user1.id}/unfollow/#{user2.id}",
        params: { token: token1 }

      user1.reload

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(user1.follows.last.target_id).to eq(user3.id)
      expect(user1.follows.count).to eq(1)
    end
  end
end
