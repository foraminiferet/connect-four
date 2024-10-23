require './lib/board'

describe Board do
  subject(:matrix) { described_class.new }

  describe '#valid_move?' do
    it 'returns true wehn move is valid' do
      valid = matrix.valid_move?(0)
      expect(valid).to be true
    end

    it 'returns false for out of bounds' do
      invalid = matrix.valid_move?(8)
      expect(invalid).to be false
    end

    it 'returns false for negative values' do
      negative = matrix.valid_move?(-1)
      expect(negative).to be false
    end

    context 'when column is full' do
      before do
        6.times do
          matrix.update_board(3, 'x')
        end
      end

      it 'returns false when to row is filled' do
        invalid = matrix.valid_move?(3)
        expect(invalid).to be false
      end
    end
  end

  describe '#next_free_position' do
    context 'when board is empty' do
      it 'returns 5 when board is empty' do
        free_position = matrix.next_free_position(1)
        expect(free_position).to eq(5)
      end
    end

    context 'when board is paritaly full' do
      before do
        2.times do
          matrix.update_board(3, 'x')
        end
      end

      it 'returns 3' do
        free_position = matrix.next_free_position(3)
        expect(free_position).to eq(3)
      end
    end
  end

  describe '#update_board' do
    context 'when board is updated' do
      before do
        matrix.update_board(0, 'x')
      end

      it 'returns x' do
        updated_variable = matrix.instance_variable_get(:@grid)[5][0]
        expect(updated_variable).to eql('x')
      end
    end
  end
end
