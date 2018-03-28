require 'rails_helper'

RSpec.describe 'TokiToki' do
  context 'Class Methods' do
    it '.encode' do
      token = TokiToki.encode('Rick Astley')

      expect(token).to match(/^[a-zA-Z0-9\-_]+?\.[a-zA-Z0-9\-_]+?\.([a-zA-Z0-9\-_]+)?$/)
    end

    it '.decode' do
      token = TokiToki.encode('Rick Astley')
      decoded_token = TokiToki.decode(token)

      expect(decoded_token[0]['sub']).to eq('Rick Astley')
    end
  end
end
