# frozen_string_literal: true

require_relative 'board'
# This class will have logic related to game
class Game
  def initialize
    @board = Board.new
  end

  def translate_user_input(position)
    array = position.split('')
    col_map = %w[a b c d e f g h]
    row_map = [0, 1, 2, 3, 4, 5, 6, 7]
    col = col_map.find_index(array.first)
    row = row_map.find_index(array.last.to_i)
    result = [row, col]
  end

  def translate_computer_input(array)
    col_map = %w[a b c d e f g h]
    row_map = %w[8 7 6 5 4 3 2 1]
    row_index, col_index = array
    (col_map[col_index] + row_map[row_index]).to_s
  end

  def play
    loop do
      puts @board
      puts 'Please chose the piece you wish to move'
      input = gets.chomp
      array = translate_user_input(input)
      # prompt user to please select the given move
      moves = @board.possible_moves_from(array)
      p translate_computer_input([4, 0])
    end
  end
end
game = Game.new
game.play
