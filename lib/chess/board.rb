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

  def display_board
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

  def find_enemy_king(color)
    king = nil
    pieces = collect_all_pieces(color)
    pieces.each { |piece| king = piece if piece.instance_of?(King) }
    king
  end

  def check_mate?(king)
    check?(king) && possible_moves_from([king.row, king.col]).empty?
    # and cant be blocked and cant be captured
  end

  def cant_be_blocked?(king)
    # but this method has a bug it only care about king adjacent square what if i can't block adjacent square but can block square before it
    # i.e: square_under_attack is d2 which cant be blocked but d4 can be and enemy is at d5 so basically i need all square leading up to checking piece
    # and exception if attacker in knight or pawn you are out of luck can't block their attack only way out is capture
    saveable_squares = []
    position_to_save = direction_of_check(king)
    collected_pieces = collect_all_pieces(king.color)
    own_pieces = collected_pieces.reject { |piece| piece.class == King }
    own_pieces.each { |piece| saveable_squares.push(possible_moves_from([piece.row, piece.col])) }
    checking_direction = position_to_save.flatten
    saveable_squares.flatten(1).include?(checking_direction)
  end

  def direction_of_check(king)
    checking_square = []
    nearby_square = king_attack_moves(king)
    nearby_square.each do |square|
      checking_square.push(square) if square_under_attack?(square[0], square[1], king.enemy_color)
    end
    checking_square
  end

  def find_attacking_piece(checking_square, king)
    # this only work if rook is attacking at white king from front
    piece = piece_at(king.row, king.col)
    row = piece.row
    col = piece.col
    path = []
    loop do
      path.push([row, col])
      row -= 1
      break unless piece_at(row, col).is_a?(String)
    end
    path.push([row, col])
  end

  # pickup adjacent square being attacked at then decrementing row/col of king upto point where current object is not of string class some piece object
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
    @board[3][3] = Rook.new("black", 3, 3, false)
    @board[6] =
      [
        Pawn.new("white", 6, 0, false),
        Pawn.new("white", 6, 1, false),
        # Pawn.new("white", 6, 2, false)
        EMPTY_SPOT,
        # Pawn.new("white", 6, 3, false)
        EMPTY_SPOT,
        # Pawn.new("white", 6, 4, false)
        EMPTY_SPOT,
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
board.display_board
# white_king = board.find_enemy_king("white")
white_king = board.piece_at(7, 3)
board.direction_of_check(white_king)
# puts white_king
# puts board.check?(white_king)
# puts board.check_mate?(white_king)
# puts board.square_under_attack?(6, 2, "black")
# puts board.square_under_attack?(6, 3, "black")
# puts board.square_under_attack?(6, 4, "black")
# nb = board.direction_of_check(white_king)
# p nb
# nearby = []
# nb.each do |element|
#   nearby << board.translate_it(element)
# end
# p nearby

# board.cant_be_blocked?(white_king)
# nb.translate_it(nb)
# just call square under attack around all king's square where ever it return's true thats direction check is coming form

# king = board.piece_at(7, 3)
# puts board.check_mate?(king)
# board.find_enemy_king("white")

# pawn = board.piece_at(6, 3)
# puts pawn.row
# puts pawn.col
# board.move_piece([6, 3], [5, 3])
# puts board
# pawna = board.piece_at(5, 3)
# p pawna.row
# p pawna.col
# puts board.check?(king)
# p board.check_mate?(king)
