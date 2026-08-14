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
  attr_reader :board
  attr_accessor :ui, :rule_engine

  include MoveCalculator

  EMPTY_SPOT = "\u2610"
  def initialize
    @board = Array.new(8) { Array.new(8) { EMPTY_SPOT } }
    populate_board
    # @ui to be remove
    @ui = UI.new
    @rule_engine = RuleEngine.new
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

  def display_board(board)
    # to be remove
    ui.display(board)
  end

  def translate_it(array)
    # to be remove
    ui.translate_computer_input(array)
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

  # For castling I probably need a new method like move pieces which moves two pieces at once
  def move_two_pieces(king_from, king_to, rook_from, rook_to)
    king = @board[king_from[0]][king_from[1]]
    rook = @board[rook_from[0]][rook_from[1]]
    king.has_moved = true if king.instance_of?(King)
    rook.has_moved = true if rook.instance_of?(Rook)
    king.row = king_to[0]
    king.col = king_to[1]
    rook.row = rook_to[0]
    rook.col = rook_to[1]
    @board[king_to[0]][king_to[1]] = king
    @board[king_from[0]][king_from[1]] = EMPTY_SPOT
    @board[rook_to[0]][rook_to[1]] = rook
    @board[rook_from[0]][rook_from[1]] = EMPTY_SPOT
  end

  def move_piece(from, to)
    piece = @board[from[0]][from[1]]
    piece.has_moved = true if piece.instance_of?(Pawn)
    piece.row = to[0]
    piece.col = to[1]
    @board[to[0]][to[1]] = piece
    @board[from[0]][from[1]] = EMPTY_SPOT
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
        Knight.new("black", 0, 1),
        Bishop.new("black", 0, 2, false),
        Queen.new("black", 0, 3, false),
        King.new("black", 0, 4, false),
        Bishop.new("black", 0, 5, false),
        Knight.new("black", 0, 6),
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
        # Knight.new("white", 7, 1)
        EMPTY_SPOT,
        # Bishop.new("white", 7, 2, false)
        EMPTY_SPOT,
        # Queen.new("white", 7, 3, false)
        EMPTY_SPOT,
        King.new("white", 7, 4, false),
        Bishop.new("white", 7, 5, false),
        Knight.new("white", 7, 6),
        Rook.new("white", 7, 7, false),
      ]
  end
end
board = Board.new
board.display_board(board.board)
# white_king = board.piece_at(7, 4)
# p board.rule_engine.queen_side_castle_possible?(white_king, board)
# board.display_board(board.board)
# board.board[7][4]
# board.board[7][0]
board.move_two_pieces([7, 4], [7, 2], [7, 0], [7, 3])
board.display_board(board.board)
# now after I fixed this (checkmate) I need to implement ent passant, castling, pawn promotion, serialization and then write tests and the project done.
