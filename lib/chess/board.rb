# frozen_string_literal: true

require_relative "move_calculator"
require_relative "pieces/pawn"
require_relative "pieces/knight"
require_relative "pieces/rook"
require_relative "pieces/bishop"
require_relative "pieces/queen"
require_relative "pieces/king"
require_relative "ui"
# All logic related to board
class Board
  attr_reader :board
  attr_accessor :ui

  include MoveCalculator

  EMPTY_SPOT = "\u2610"
  def initialize
    @board = Array.new(8) { Array.new(8) { EMPTY_SPOT } }
    populate_board
    @ui = UI.new
  end

  def piece_at(row, col)
    @board[row][col]
  end

  def row(row)
    @board[row]
  end

  def display_board(board)
    ui.display(board)
  end

  def translate_it(array)
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
    piece.row = to[0]
    piece.col = to[1]
    @board[to[0]][to[1]] = piece
    @board[from[0]][from[1]] = EMPTY_SPOT
  end

  def square_under_attack?(row, col, enemy_color)
    moves = []
    enemies = collect_all_pieces(enemy_color)
    enemies.each do |enemy|
      if enemy.instance_of?(Pawn)
        moves << pawn_attack_moves(enemy)
      elsif enemy.instance_of?(King)
        moves << king_attack_moves(enemy)
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

  def king_attack_moves(king)
    attacked_squares = []

    (-1..1).each do |row_offset|
      (-1..1).each do |col_offset|
        next if row_offset.zero? && col_offset.zero?

        target_row = king.row + row_offset
        target_col = king.col + col_offset

        attacked_squares << [target_row, target_col] if target_row.between?(0, 7) && target_col.between?(0, 7)
      end
    end

    attacked_squares
  end

  def find_king(color)
    king = nil
    pieces = collect_all_pieces(color)
    pieces.each { |piece| king = piece if piece.instance_of?(King) }
    king
  end

  def check_mate?(king)
    check?(king) && possible_moves_from([king.row, king.col]).empty? && !can_escape?(king)
  end

  def valid_moves(king)
    saveable_squares = []
    collected_pieces = collect_all_pieces(king.color)
    own_pieces = collected_pieces.reject { |piece| piece.class == King }
    own_pieces.each { |piece| saveable_squares.push(possible_moves_from([piece.row, piece.col])) }
    saveable_squares.flatten(1)
  end

  def can_escape?(king)
    dummy_board = Marshal.load(Marshal.dump(self))
    dummy_king = dummy_board.find_king(king.color)
    collected_move = dummy_board.valid_moves(dummy_king)
    collected_move.each do |row, col|
      original_state = dummy_board.board[row][col]
      dummy_board.board[row][col] = Knight.new(dummy_king.color, row, col)
      return true if dummy_board.check?(dummy_king) == false

      dummy_board.board[row][col] = original_state
    end
    false
  end

  def check?(king)
    square_under_attack?(king.row, king.col, king.enemy_color)
  end

  private

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
        King.new("black", 0, 3, false),
        Queen.new("black", 0, 4, false),
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

# now after I fixed this (checkmate) I need to implement ent passant, castling, pawn promotion, serialization and then write tests and the project done.

board = Board.new
board.display_board(board.board)
white_king = board.piece_at(7, 3)
board.can_be_blocked?(white_king)
