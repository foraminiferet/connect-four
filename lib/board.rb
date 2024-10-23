require_relative 'figurines'

# Board class wwith methods for diplaye and updating the board
class Board
  include Figurines
  attr_reader :grid

  def initialize
    @grid = Array.new(6) { Array.new(7) { blank_circle } }
  end

  def display_board
    puts '-----------------'
    puts
    grid.each do |row|
      puts " #{row.join(' ')}"
    end
    puts " #{(1..7).to_a.join(' ')}"
    puts
    puts '-----------------'
  end

  def update_board(input, symbol)
    free_position = next_free_position(input)
    @grid[free_position][input] = symbol
  end

  def next_free_position(input)
    5.downto(0) do |i|
      return i if @grid[i][input] == blank_circle
    end
  end

  def valid_move?(input)
    input.between?(0, 6) && @grid[0][input] == blank_circle
  end
end
