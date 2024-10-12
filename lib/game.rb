require_relative 'board'
require_relative 'database'
require_relative 'player'
require_relative 'figurines'

class Game
  include Figurines

  def initialize
    @board = Board.new
    @player_one = Player.new(yellow_circle, 'Player 1')
    @player_two = Player.new(red_circle, 'Player 2')
    @round = 0
  end

  def play
    game_intructions
    loop do
      active_player = current_player
      @board.display_board
      row_index, column_index = player_input(active_player)
      validate_move(row_index, column_index)
      @board.update_board(row_index, column_index, active_player.symbol)

      break if game_over?(row_index, column_index, active_player.symbol)
    end
    @board.display_board
  end

  def validate_move(row_index, column_index)
    until @board.valid_move?(row_index, column_index)
      puts 'Ivalid move'
      row_index, column_index = player_input(active_player)
    end
  end

  def player_input(active_player)
    puts "#{active_player.name}'s turn.\nPlease enter the row and colum you want to fill in format aXb(exmp. 1x3): "
    input = nil
    loop do
      input = gets.chomp
      break if valid_input?(input)

      puts 'Incorrect forma entered, please try agin.'
    end
    row_index = input[0].to_i - 1
    column_index = input[2].to_i - 1
    [row_index, column_index]
  end

  def valid_input?(input)
    if input =~ /^(\d)x(\d)$/i
      first_number = ::Regexp.last_match(1).to_i
      second_number = ::Regexp.last_match(2).to_i
      first_number.between?(1, 6) && second_number.between?(1, 7)
    else
      false
    end
  end

  def current_player
    @round += 1
    @round.odd? ? @player_one : @player_two
  end

  def game_over?(last_row, last_column, symbol)
    if player_won?(last_row, last_column, symbol)
      puts "Player #{current_player.name} wins!"
      return true
    elsif board_full?
      puts "It's a draw!"
      return true
    end
    false
  end

  def board_full?
    @board.grid.flatten.none? { |cell| cell == blank_circle }
  end

  def player_won?(row, colunm, symbol)
    vertical_win?(row, colunm, symbol) ||
      horizontal_win?(row, colunm, symbol) ||
      diagonal_win?(row, colunm, symbol)
  end

  # TODO: connect four methods don't work as expected

  # We subtract the one in the winning conditions count because:
  # we start checking for four in a row from the current position in 2 directions simultaneously
  # and since we start form the current positon for connect four both directions contain the starting position
  # so we need to  subtract the overlap(the starting position)
  #  1 + consecutive_connected that 1 is the starting position that we are adding to both directions

  # Check if we have four connected in a column
  def vertical_win?(row, col, symbol)
    count = consecutive_connected(row - 1, col, -1, 0,
                                  symbol) + consecutive_connected(row + 1, col, 1, 0, symbol) - 1
    p count
    count >= 4
  end

  # Check for four in a row same explanation for subtracting 1 as in the vertical
  def horizontal_win?(row, col, symbol)
    count = consecutive_connected(row, col - 1, 0, -1,
                                  symbol) + consecutive_connected(row, col + 1, 0, 1, symbol) - 1
    p count
    count >= 4
  end

  # Chech the left and right diagonal for four connected
  def diagonal_win?(row, col, symbol)
    count1 = consecutive_connected(row - 1, col - 1, -1, -1,
                                   symbol) + consecutive_connected(row + 1, col + 1, 1, 1, symbol) - 1
    count2 = consecutive_connected(row - 1, col + 1, -1, 1,
                                   symbol) + consecutive_connected(row + 1, col - 1, 1, -1, symbol)
    (count1 >= 4) || (count2 >= 4)
  end

  # Checking for consecutive connectd
  def consecutive_connected(row, column, row_delta, col_delta, symbol)
    return 0 if row < 0 || row >= 6 || column < 0 || column >= 7
    return 0 if @board.grid[row][column] != symbol

    1 + consecutive_connected(row + row_delta, column + col_delta, row_delta, col_delta, symbol)
  end

  private

  def game_intructions
    puts <<-HEREDOCS
      Welcome to the connect four termianal game.
      This is a two player game, where the goal is to connect four dots in a row.
      Each round one player gets to put a circle in a specified position.
      The game ends when one player connects 4 or the board gets full.
    HEREDOCS
  end
end
