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
    col = { 0 => 'a', 1 => 'b', 2 => 'c', 3 => 'd', 4 => 'e', 5 => 'f', 6 => 'g', 7 => 'h' }
    row = { '8' => 0, '7' => 1, '6' => 2, '5' => 3, '4' => 4, '3' => 5, '2' => 6, '1' => 7 }
    create_readable_data(array, col, row)
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

  def create_readable_data(array, col, row)
    row_number = array.first
    col_number = array.last
    suffix = row[row_number]
    prefix = col[col_number]
    prefix + suffix
  end

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
