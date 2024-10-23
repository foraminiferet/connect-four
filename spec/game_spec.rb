require './lib/game'

describe Game do
  subject(:game) { described_class.new }

  before do
    # Set up the board grid manually for testing
    game.instance_variable_get(:@board).instance_variable_set(:@grid, [
                                                                [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                                                                [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                                                                [' ', ' ', 'X', 'X', ' ', ' ', ' '],
                                                                [' ', ' ', 'X', 'X', ' ', ' ', ' '],
                                                                [' ', 'X', 'X', 'X', 'X', ' ', ' '],
                                                                ['X', ' ', 'X', ' ', ' ', 'X', ' ']
                                                              ])
  end

  describe '#consecutive_connected' do
    it 'returns the correct count for vertical connections' do
      result = game.consecutive_connected(5, 2, -1, 0, 'X')
      expect(result).to eq(4)
    end
  end

  describe '#vertical_win?' do
    it 'returns true if there is 4 in a column' do
      result = game.vertical_win?(2, 2, 'X')
      expect(result).to be true
    end

    it 'returns false if there is not 4 in a column' do
      result = game.vertical_win?(1, 2, 'X')
      expect(result).to be false
    end
  end

  describe '#horizontal_win?' do
    it 'returns true for 4 in a row' do
      result = game.horizontal_win?(4, 2, 'X')
      expect(result).to be true
    end

    it 'returns false if there is not 4 in a row' do
      result = game.horizontal_win?(0, 5, 'X')
      expect(result).to be false
    end
  end

  describe '#diagonal_win?' do
    it 'returns true for left diagonal' do
      result = game.diagonal_win?(3, 2, 'X')
      expect(result).to be true
    end

    it 'returns true for right diagonal' do
      result = game.diagonal_win?(2, 2, 'X')
      expect(result).to be true
    end

    it 'returns false if there are not 4 connected in diagonal' do
      result = game.diagonal_win?(4, 2, 'X')
      expect(result).to be false
    end
  end

  describe '#player_won?' do
    it 'returns true when there is a win condition' do
      result = game.player_won?(2, 2, 'X')
      expect(result).to be true
    end
  end

  describe '#game_over?' do
    it 'returns true when player wins' do
      result = game.game_over?(2, 2, 'X')
      expect(result).to be true
    end
  end

  describe '#single_digit?' do
    it 'returns true for 3' do
      expect(game.single_digit?('3')).to be true
    end

    it 'returns false for 12' do
      expect(game.single_digit?('12')).to be false
    end
  end

  describe '#valid_input' do
    before do
      # Stub the player_input method to control user input
      allow(game).to receive(:player_input).and_return(*inputs)
    end

    context 'when input is valid' do
      let(:inputs) { ['3'] } # Simulate valid input

      it 'returns the valid input' do
        expect(game.valid_input).to eq('3')
      end
    end

    context 'when input is invalid' do
      let(:inputs) { %w[8 a 3] } # Simulate two invalid inputs followed by a valid one

      it 'prompts the user to try again until valid input is received' do
        expect { game.valid_input }.to output(/Incorrect input please try again/).to_stdout
        expect(game.valid_input).to eq('3')
      end
    end

    context 'when input is empty' do
      let(:inputs) { ['', '2'] } # Simulate empty input followed by a valid input

      it 'prompts the user to try again until valid input is received' do
        expect { game.valid_input }.to output(/Incorrect input please try again/).to_stdout
        expect(game.valid_input).to eq('2')
      end
    end
  end

  describe '#piece_position' do
    before do
      # Stub valid_input to control user input
      allow(game).to receive(:valid_input).and_return(input)
    end

    context 'when input is valid' do
      let(:input) { '3' } # Simulate valid input for column 3 (index 2)

      before do
        # Stub next_free_position to return the first available row for the column
        allow(game.instance_variable_get(:@board)).to receive(:next_free_position).with(2).and_return(5)
      end

      it 'returns the correct row and column indices' do
        expect(game.piece_position).to eq([5, 2]) # Expecting row 5, column index 2 (for input 3)
      end
    end

    context 'when input is valid but column is full' do
      let(:input) { '1' } # Simulate valid input for column 1 (index 0)

      before do
        # Stub next_free_position to return nil or an invalid row index (indicating the column is full)
        allow(game.instance_variable_get(:@board)).to receive(:next_free_position).with(0).and_return(nil)
      end

      it 'returns nil for the row index' do
        expect(game.piece_position).to eq([nil, 0]) # Expecting nil for full column
      end
    end
  end
end
