# frozen_string_literal: true

require 'spec_helper'

describe Game, type: :model do
  subject(:game) { build(:game) }

  describe 'validations' do
    it do
      expect(game).to validate_presence_of(:name)
    end

    it do
      expect(game).to validate_length_of(:name)
        .is_at_most(50)
    end

    it do
      expect(game).to validate_presence_of(:user)
    end
  end
end
