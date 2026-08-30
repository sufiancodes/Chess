# frozen_string_literal: true

require_relative "move_calculator"
require_relative "pieces/pawn"
require_relative "pieces/knight"
require_relative "pieces/rook"
require_relative "pieces/bishop"
require_relative "pieces/queen"
require_relative "pieces/king"
require_relative "ui"
require_relative "rule_engine"
# All logic related to board
class Board
  attr_accessor :board

  include MoveCalculator

  EMPTY_SPOT = "\u2610"
  def initialize
    @board = Array.new(8) { Array.new(8) { EMPTY_SPOT } }
    populate_board
  end

  def piece_at(row, col)
    @board[row][col]
  end

  def row(row)
    @board[row]
  end

  def column(col)
    rotated_board = @board.transpose
    rotated_board[col]
  end

  def empty_at?(row, col)
    piece_at(row, col) == EMPTY_SPOT
  end

  def enemy_at?(own_color, row, col)
    piece = piece_at(row, col)
    return false if piece.is_a?(String) || piece.nil?

    enemy_color = piece.color
    own_color.eql?(enemy_color) ? false : true
  end

  def friendly_at?(own_color, row, col)
    piece = piece_at(row, col)
    return false if piece.is_a?(String) || piece.nil?

    true if piece.color == own_color
  end

  def move_two_pieces(king_from, king_to, rook_to)
    rook_from = find_rook(king_from, king_to)
    move_piece(king_from, king_to)
    move_piece(rook_from, rook_to)
  end

  def move_piece(from, to)
    piece = @board[from[0]][from[1]]
    piece.has_moved = true if piece.instance_of?(Pawn)
    piece.has_moved = true if piece.instance_of?(Rook)
    piece.has_moved = true if piece.instance_of?(King)
    piece.row = to[0]
    piece.col = to[1]
    @board[to[0]][to[1]] = piece
    @board[from[0]][from[1]] = EMPTY_SPOT
  end

  def promote_pawn(pawn)
    color = pawn.color
    row = pawn.row
    col = pawn.row
    board[row][col] = Queen.new(color, row, col, false)
  end

  def find_rook(king_from, king_to)
    rook = []
    king = piece_at(king_from[0], king_from[1])
    rook << 7 if king.color == "white"
    rook << 0 if king.color == "black"
    rook << 0 if king_to[1] == 2
    rook << 7 if king_to[1] == 6
    rook
  end

  def find_king(color)
    king = nil
    pieces = collect_all_pieces(color)
    pieces.each { |piece| king = piece if piece.instance_of?(King) }
    king
  end

  def collect_all_pieces(color)
    enemies = []
    @board.each do |row|
      row.each { |piece| enemies.push(piece) if !piece.is_a?(String) && piece.color == color }
    end
    enemies
  end

  def populate_board
    @board[0] =
      [
        Rook.new("black", 0, 0, false),
        Knight.new("black", 0, 1, false),
        Bishop.new("black", 0, 2, false),
        Queen.new("black", 0, 3, false),
        King.new("black", 0, 4, false),
        Bishop.new("black", 0, 5, false),
        Knight.new("black", 0, 6, false),
        Rook.new("black", 0, 7, false),
      ]
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
        Knight.new("white", 7, 1, false),
        Bishop.new("white", 7, 2, false),
        Queen.new("white", 7, 3, false),
        King.new("white", 7, 4, false),
        Bishop.new("white", 7, 5, false),
        Knight.new("white", 7, 6, false),
        Rook.new("white", 7, 7, false),
      ]
  end
end
