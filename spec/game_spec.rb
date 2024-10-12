require './lib/game'

describe Game do
  subject(:game) { described_class.new }

  describe '#player_won?' do
    before do
      allow_any_instance_of(Board).to receive(:update_board).and_return true
    end

    context 'when a player has four connected horizontaly' do
    end
  end
end
