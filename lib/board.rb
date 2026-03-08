# frozen_string_literal: true

# All logic related to board
class Board
  attr_accessor :board

  EMPTY_SPOT = "\u2610"
  def initialize
    @board = Array.new(8) { Array.new(8) { EMPTY_SPOT } }
  end

  def to_s
    col_alphabets = "\n a b c d e f g h"
    row_numbers = [8, 7, 6, 5, 4, 3, 2, 1]
    populate_board
    board.map.with_index { |row, index| "#{row_numbers[index]} " + row.join(' ').to_s }.join("\n") + col_alphabets
  end

  private

  def populate_board
    @board [0] = ["\u2656", "\u2658", "\u2657", "\u2654", "\u2655", "\u2657", "\u2658", "\u2656"]
    @board [1] = ["\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659"]
    @board [6] = ["\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F"]
    @board [7] = ["\u265C", "\u265E", "\u265D", "\u265A", "\u265B", "\u265D", "\u265E", "\u265C"]
  end
end
board = Board.new
puts board
