require_relative 'figurines'

class Board
  include Figurines
  attr_reader :grid

  def initialize
    @grid = Array.new(6) { Array.new(7) { blank_circle } }
  end

  def display_board
    puts
    grid.each_with_index do |row, index|
      puts "#{index + 1} #{row.join(' ')}"
    end
    puts "  #{(1..7).to_a.join(' ')}"
    puts
    puts '-----------------'
  end

  def update_board(row, colum, symbol)
    @grid[row - 1][colum - 1] = symbol
  end

  def valid_move?(row, colum)
    row.between?(1, 6) && colum.between?(1, 7) && @grid[row - 1][colum - 1] == blank_circle
  end
end
