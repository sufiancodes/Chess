# frozen_string_literal: true

# this module calculate moves for all the pieces
module MoveCalculator
  def self.legal_moves(row, col, board)
    piece = board.piece_at(row, col)
    color = piece.color

    case piece
    when Pawn
      calculate_pawn_moves(row, col, color, piece, board)
      # when Rook
      #   calculate_rook_moves(position, board, color)
    end
  end

  def self.calculate_pawn_moves(row, col, color, piece, board)
    if color == 'white'
      calculate_white_pawn_moves(row, col, piece, board)
    elsif color == 'black'
      calculate_black_pawn_moves(row, col, piece, board)
    end
  end

  private

  def self.calculate_black_pawn_moves(row, col, piece, board)
    moves = []
    next_square = board.piece_at(row + 1, col)
    second_next_square = board.piece_at(row + 2, col)
    left_diagonal = board.piece_at(row + 1, col - 1)
    right_diagonal = board.piece_at(row + 1, col + 1)
    empty = "\u2610"

    # starter move when board is clear and pawn hasn't move yet
    moves << [row + 2, col] if piece.has_move == false && next_square == empty && second_next_square == empty

    # starter move when pawn hasn't move and board is little clear not too clear
    moves << [row + 1, col] if piece.has_move == false && next_square == empty && second_next_square != empty

    # regular one square movement
    moves << [row + 1, col] if next_square == empty && piece.has_move == true

    # capture left diagonal
    moves << [row + 1, col - 1] if left_diagonal == empty && piece.color != 'black'

    # capture right diagonal
    moves << [row + 1, col + 1] if right_diagonal == empty && piece.color != 'black'

    p moves
  end
end
# do the singleton class

# why aren't you capturing bro
