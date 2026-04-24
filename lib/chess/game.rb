# frozen_string_literal: true

require_relative 'board'
# This class will have logic related to game
class Game
  def initialize
    @board = Board.new
  end

  def translate_user_input(position)
    col = { 'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7 }
    row = { '0' => 8, '1' => 7, '2' => 6, '3' => 5, '4' => 4, '5' => 3, '6' => 2, '7' => 1 }
    create_useable_array(position, col, row)
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

  private

  def create_useable_array(position, col_alphabets, row_numbers)
    pos = position.split('')
    column = pos.first
    row = pos.last
    prefix = row_numbers[row]
    suffix = col_alphabets[column]
    result = []
    result << prefix
    result << suffix
    result
  end
end
game = Game.new
# game.play
p translate_computer_input([4, 0])
