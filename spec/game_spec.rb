require './lib/game'

describe Game do
  subject(:game) { described_class.new }

  describe '#valid_input?' do
    context 'when input is valid' do
      it "returns true for '3x3'" do
        correct_input = game.valid_input?('3x3')
        expect(correct_input).to be true
      end

      it "returns true for '4x1'" do
        correct_input = game.valid_input?('4x1')
        expect(correct_input).to be true
      end
    end

    context 'when input is false' do
      it "returns false when the second charcter isn't x" do
        wrong_input = game.valid_input?('4ab')
        expect(wrong_input).to be false
      end

      it 'returns false when input is contains 2 non digit characters' do
        wrong_input = game.valid_input?('ax3')
        expect(wrong_input).to be false
      end

      it 'returns false when input is out of bounds' do
        wrong_input = game.valid_input?('12x2')
        expect(wrong_input).to be false
      end
    end
  end

  describe '#prompt_for_valid_input' do
    context 'when valid input is provided' do
      before do
        allow(game).to receive(:player_input).and_return('1x3')
      end

      it 'returns the inputs string' do
        expect(game.prompt_for_valid_input).to eq('1x3')
      end
    end

    context 'when user inputs an incorrect value once, then a valid input' do
      before do
        letter = 'a'
        valid_input = '4x2'
        allow(game).to receive(:player_input).and_return(letter, valid_input)
      end

      it 'completes loop and displays error message once' do
        expect(game).to receive(:puts).with('Incorrect format entered, please try again.').once
        game.prompt_for_valid_input
      end
    end

    context 'when user inputs tow incorrect values, then a correct one' do
      before do
        out_of_bounds = '7x1'
        empty_string = ''
        valid_input = '5x2'
        allow(game).to receive(:player_input).and_return(out_of_bounds, empty_string, valid_input)
      end

      it 'prompts user until valid input is given' do
        expect(game).to receive(:puts).with('Incorrect format entered, please try again.').twice
        game.prompt_for_valid_input
      end
    end
  end

  describe '#turn_input' do
    context 'when user input is valid' do
      it 'returns tow digit array that are one less than the input' do
        allow(game).to receive(:prompt_for_valid_input).and_return('3x1')
        expect(game.turn_input).to eql([2, 0])
      end
    end
  end
end
