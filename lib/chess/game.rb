# frozen_string_literal: true

require_relative 'board'
# This class will have logic related to game
class Game
  def translate_user_input(position)
    col = { 'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7 }
    row = { '0' => 8, '1' => 7, '2' => 6, '3' => 5, '4' => 4, '5' => 3, '6' => 2, '7' => 1 }
    create_useable_array(position, col, row)
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
