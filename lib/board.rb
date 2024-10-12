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

  def update_board(row, column, symbol)
    @grid[row][column] = symbol
  end

  def valid_move?(row, column)
    row.between?(0, 5) && column.between?(0, 6) && @grid[row][column] == blank_circle
  end
end
