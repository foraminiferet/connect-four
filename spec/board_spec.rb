require './lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#valid_move?' do
    it 'returns true for valid move' do
      expect(board.valid_move?(1, 1)).to be true
    end

    it 'returns false for an occupied cell' do
      board.update_board(1, 1, 'a')
      expect(board.valid_move?(1, 1)).to be false
    end

    it 'returns false when move is out of bounds' do
      expect(board.valid_move?(-1, 5)).to be false
      expect(board.valid_move?(1, 9)).to be false
    end
  end

  describe '#update_board' do
    it 'updates board correctly' do
      board.update_board(1, 1, 'x')
      expect(board.grid[0][0]).to eql('x')
    end
  end
end
