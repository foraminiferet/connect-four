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
    @round = 1
  end

  # TO PLAYSER INPUT, VALIDATION, GAME WIN CONDITIONS
  def play
    game_intructions
    @board.display_board
    loop do
      input = player_input
      input = player_input unless valid_input?(input)
      row, column = turn_outcome(input.to_i - 1)
      break if game_over?(row, column, current_player.symbol)
    end
    @board.display_board
  end

  def turn_outcome(input)
    row = @board.next_free_position(input)
    @board.update_board(input, current_player.symbol)
    @board.display_board
    [row, input]
  end

  # Validation for user input
  def valid_input?(input)
    if input =~ /\A[1-7]\z/ && @board.valid_move?(input.to_i - 1)
      true
    else
      puts 'Incorrect input entered please try again'
      false
    end
  end

  # Get user input form stdin
  def player_input
    puts "#{current_player.name}'s turn.\nPlease enter the colum you want to fill in [1-7](exmp. '1'): "
    gets.chomp
  end

  # Keeps track of current player
  def current_player
    @round.odd? ? @player_one : @player_two
  end

  # We update the board the final time so thath the output would be correct
  def game_over?(last_row, last_column, symbol)
    @board.update_board(last_row, last_column, symbol)
    if player_won?(last_row, last_column, symbol)
      puts "Congradulations: #{current_player.name} wins!"
      return true
    elsif board_full?
      puts "It's a draw!"
      return true
    end
    false
  end

  # For drawn games
  def board_full?
    @board.grid.flatten.none? { |cell| cell == blank_circle }
  end

  # Player win conditions
  def player_won?(row, colunm, symbol)
    vertical_win?(row, colunm, symbol) ||
      horizontal_win?(row, colunm, symbol) ||
      diagonal_win?(row, colunm, symbol)
  end

  # Check if we have four connected in a column
  def vertical_win?(row, col, symbol)
    count = consecutive_connected(row - 1, col, -1, 0, symbol) + consecutive_connected(row + 1, col, 1, 0, symbol) + 1
    count >= 4
  end

  # Check for four in a row same explanation for subtracting 1 as in the vertical
  def horizontal_win?(row, col, symbol)
    count = consecutive_connected(row, col - 1, 0, -1, symbol) + consecutive_connected(row, col + 1, 0, 1, symbol) + 1
    count >= 4
  end

  # Chech the left and right diagonal for four connected
  def diagonal_win?(row, col, symbol)
    count_left_diagonal = consecutive_connected(row - 1, col - 1, -1, -1,
                                                symbol) + consecutive_connected(row + 1, col + 1, 1, 1, symbol) + 1
    count_right_diagonal = consecutive_connected(row - 1, col + 1, -1, 1,
                                                 symbol) + consecutive_connected(row + 1, col - 1, 1, -1, symbol) + 1
    (count_left_diagonal >= 4) || (count_right_diagonal >= 4)
  end

  # Checking for consecutive connectd
  def consecutive_connected(row, column, row_delta, col_delta, symbol)
    return 0 if row.negative? || row >= 6 || column.negative? || column >= 7
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
