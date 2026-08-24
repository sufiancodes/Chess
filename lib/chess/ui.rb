# frozen_string_literal: true

# this class deals with UI and display
class UI
  def display(board)
    col_alphabets = "\n  a b c d e f g h"
    row_numbers = [8, 7, 6, 5, 4, 3, 2, 1]
    puts board.map.with_index { |row, index| "#{row_numbers[index]} " + row.join(" ").to_s }.join("\n") + col_alphabets
  end

  def translate_user_input(position)
    col = { "a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7 }
    row = { "1" => 7, "2" => 6, "3" => 5, "4" => 4, "5" => 3, "6" => 2, "7" => 1, "8" => 0 }
    create_useable_array(position, col, row)
  end

  def translate_castling_computer_input(array)
    first_half, second_half = array.each_slice(2).to_a
    first_square = translate_computer_input(first_half)
    second_square = translate_computer_input(second_half)
    first_square + second_square
  end

  def translate_computer_input(array)
    if array.length == 4
      translate_castling_computer_input(array)
    else
      col_map = ["a", "b", "c", "d", "e", "f", "g", "h"]
      row_map = ["8", "7", "6", "5", "4", "3", "2", "1"]
      row_index, col_index = array
      (col_map[col_index] + row_map[row_index]).to_s
    end
  end

  def create_useable_array(position, col_alphabets, row_numbers)
    pos = position.split("")
    column = pos[0]
    row = pos[1]
    [row_numbers[row], col_alphabets[column]]
  end

  def translate_castling_input(position)
    # first cut these c1d1 string in half
    destination = []
    moves = position.chars.each_slice(position.length / 2).map(&:join)
    moves.each { |move| destination << translate_user_input(move) }
    destination
  end
end
ui = UI.new
p ui.translate_user_input("a1")