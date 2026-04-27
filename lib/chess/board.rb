# frozen_string_literal: true

require_relative 'move_calculator'
require_relative 'pieces/pawn'
# All logic related to board
class Board
  include MoveCalculator

  EMPTY_SPOT = "\u2610"
  def initialize
    @board = Array.new(8) { Array.new(8) { EMPTY_SPOT } }
    populate_board
  end

  def to_s
    col_alphabets = "\n a b c d e f g h"
    row_numbers = [8, 7, 6, 5, 4, 3, 2, 1]
    @board.map.with_index { |row, index| "#{row_numbers[index]} " + row.join(' ').to_s }.join("\n") + col_alphabets
  end

  def piece_at(row, col)
    @board [row][col]
  end

  def possible_moves_from(array)
    MoveCalculator.legal_moves(array[0], array[1], self)
  end

  def move_piece(from, to)
    # I can also use just 2 arguments as arrays one os to array other is from
    piece = @board [from[0]] [from[1]]
    @board [to[0]] [to[1]] = piece
    @board [from[0]] [from[1]] = EMPTY_SPOT
  end

  private

  def populate_board
    @board [0] = ["\u2656", "\u2658", "\u2657", "\u2654", "\u2655", "\u2657", "\u2658", "\u2656"]
    @board [1] =
      [Pawn.new('black', 1, 0, false), Pawn.new('black', 1, 1, false), Pawn.new('black', 1, 2, false),
       Pawn.new('black', 1, 3, false), Pawn.new('black', 1, 4, false), Pawn.new('black', 1, 5, false), Pawn.new('black', 1, 6, false), Pawn.new('black', 1, 7, false)]
    @board [6] =
      [Pawn.new('white', 6, 0, false), Pawn.new('white', 6, 1, false), Pawn.new('white', 6, 2, false),
       Pawn.new('white', 6, 3, false), Pawn.new('white', 6, 4, false), Pawn.new('white', 6, 5, false), Pawn.new('white', 6, 6, false), Pawn.new('white', 6, 7, false)]
    @board [7] = ["\u265C", "\u265E", "\u265D", "\u265A", "\u265B", "\u265D", "\u265E", "\u265C"]
  end
end