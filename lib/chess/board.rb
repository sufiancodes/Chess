# frozen_string_literal: true

require_relative "move_calculator"
require_relative "pieces/pawn"
require_relative "pieces/knight"
require_relative "pieces/rook"
require_relative "pieces/bishop"
require_relative "pieces/queen"
require_relative "pieces/king"
# All logic related to board
class Board
  include MoveCalculator

  EMPTY_SPOT = "\u2610"
  def initialize
    @board = Array.new(8) { Array.new(8) { EMPTY_SPOT } }
    populate_board
  end

  def to_s
    col_alphabets = "\n  a b c d e f g h"
    row_numbers = [8, 7, 6, 5, 4, 3, 2, 1]
    @board.map.with_index { |row, index| "#{row_numbers[index]} " + row.join(" ").to_s }.join("\n") + col_alphabets
  end

  def piece_at(row, col)
    @board[row][col]
  end

  def row(row)
    @board[row]
  end

  def empty_at?(row, col)
    piece_at(row, col) == EMPTY_SPOT
  end

  def enemy_at?(own_color, row, col)
    piece = piece_at(row, col)
    return false if piece.is_a?(String)

    enemy_color = piece.color
    own_color.eql?(enemy_color) ? false : true
  end

  def friendly_at?(own_color, row, col)
    piece = piece_at(row, col)
    return false if piece.is_a?(String)

    true if piece.color == own_color
  end

  def column(col)
    rotated_board = @board.transpose
    rotated_board[col]
  end

  def possible_moves_from(array)
    MoveCalculator.legal_moves(array[0], array[1], self)
  end

  def move_piece(from, to)
    piece = @board[from[0]][from[1]]
    piece.has_moved = true if piece.instance_of?(Pawn)
    @board[to[0]][to[1]] = piece
    @board[from[0]][from[1]] = EMPTY_SPOT
  end

  def square_under_attack?(row, col, enemy_color)
    moves = []
    enemies = collect_all_enemy_pieces(enemy_color)
    enemies.each do |enemy|
      if enemy.instance_of?(Pawn)
        moves << pawn_attack_moves(enemy)
      else
        moves.push(possible_moves_from([enemy.row, enemy.col]))
      end
    end
    enemy_moves = moves.flatten(1)
    enemy_moves.include?([row, col])
  end

  def pawn_attack_moves(enemy)
    moves = []
    direction = enemy.color == "white" ? -1 : +1
    [-1, + 1].each do |delta|
      column = enemy.col + delta
      moves.push([enemy.row + direction, column]) if column.between?(0, 7) && (enemy.row + direction).between?(0, 7)
    end
    moves
  end

  def check_mate?(piece)
    check?(piece) && possible_moves_from([piece.row, piece.col]).empty?
  end

  def check?(piece)
    square_under_attack?(piece.row, piece.col, piece.enemy_color)
  end

  private

  def collect_all_enemy_pieces(enemy_color)
    enemies = []
    @board.each do |row|
      row.each { |piece| enemies.push(piece) if !piece.is_a?(String) && piece.color == enemy_color }
    end
    enemies
  end

  def populate_board
    @board[0] =
      [
        Rook.new("black", 0, 0, false),
        Knight.new("black", 0, 1),
        Bishop.new("black", 0, 2, false),
        King.new("black", 0, 3, false),
        Queen.new("black", 0, 4, false),
        Bishop.new("black", 0, 5, false),
        Knight.new("black", 0, 6),
        Rook.new("black", 0, 7, false),
      ]
    # @board[4][3] = Queen.new("black", 4, 3, false)
    @board[1] =
      [
        Pawn.new("black", 1, 0, false),
        Pawn.new("black", 1, 1, false),
        Pawn.new("black", 1, 2, false),
        Pawn.new("black", 1, 3, false),
        Pawn.new("black", 1, 4, false),
        Pawn.new("black", 1, 5, false),
        Pawn.new("black", 1, 6, false),
        Pawn.new("black", 1, 7, false),
      ]
    @board[6] =
      [
        Pawn.new("white", 6, 0, false),
        Pawn.new("white", 6, 1, false),
        Pawn.new("white", 6, 2, false),
        Pawn.new("white", 6, 3, false),
        Pawn.new("white", 6, 4, false),
        Pawn.new("white", 6, 5, false),
        Pawn.new("white", 6, 6, false),
        Pawn.new("white", 6, 7, false),
      ]
    @board[7] =
      [
        Rook.new("white", 7, 0, false),
        Knight.new("white", 7, 1),
        Bishop.new("white", 7, 2, false),
        King.new("white", 7, 3, false),
        Queen.new("white", 7, 4, false),
        Bishop.new("white", 7, 5, false),
        Knight.new("white", 7, 6),
        Rook.new("white", 7, 7, false),
      ]
  end
end

board = Board.new
puts board
king = board.piece_at(7, 3)
# puts board.check?(king)
p board.check_mate?(king)
# now after this sort king works fine I need to implement two method on board check_mate? and over?
