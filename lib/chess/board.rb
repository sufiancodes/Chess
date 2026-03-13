# frozen_string_literal: true

require_relative 'pieces/pawn'
# All logic related to board
class Board
  attr_accessor :board

  EMPTY_SPOT = "\u2610"
  def initialize
    @board = Array.new(8) { Array.new(8) { EMPTY_SPOT } }
    populate_board
  end

  def to_s
    col_alphabets = "\n a b c d e f g h"
    row_numbers = [8, 7, 6, 5, 4, 3, 2, 1]
    board.map.with_index { |row, index| "#{row_numbers[index]} " + row.join(' ').to_s }.join("\n") + col_alphabets
  end

  def at(row, col)
    board[row][col]
  end

  def possible_moves_from(row, col)
    piece = at(row, col)
    piece.move(board, row, col)
  end

  def move_piece(from_row, form_col, to_row, to_col)
    # this method will mutate board
  end

  private

  def populate_board
    @board [0] = ["\u2656", "\u2658", "\u2657", "\u2654", "\u2655", "\u2657", "\u2658", "\u2656"]
    @board [1] = [Pawn.new('black'), "\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659"]
    @board [6] = ["\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F"]
    @board [7] = ["\u265C", "\u265E", "\u265D", "\u265A", "\u265B", "\u265D", "\u265E", "\u265C"]
  end
end
board = Board.new
puts board
# pawn = board.at(1, 0)
# p pawn
board.possible_moves_from(1, 0)
puts board

