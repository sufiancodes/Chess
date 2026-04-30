# frozen_string_literal: true

# this module calculate moves for all the pieces
module MoveCalculator
  class << self
    def legal_moves(row, col, board)
      piece = board.piece_at(row, col)
      color = piece.color

      case piece
      when Pawn
        calculate_pawn_moves(row, col, color, piece, board)
        # when Rook
        #   calculate_rook_moves(position, board, color)
      end
    end

    def calculate_pawn_moves(row, col, color, piece, board)
      if color == 'white'
        calculate_white_pawn_moves(row, col, piece, board)
      elsif color == 'black'
        calculate_black_pawn_moves(row, col, piece, board)
      end
    end

    private

    def calculate_black_pawn_moves(row, col, piece, board)
      moves = []
      next_square = row == 7 ? board.piece_at(row, col) : board.piece_at(row + 1, col)
      second_next_square = board.piece_at(row + 2, col)
      left_diagonal_piece = col.zero? ? board.piece_at(row, col) : board.piece_at(row + 1, col - 1)
      right_diagonal_piece = col == 7 ? board.piece_at(row, col) : board.piece_at(row + 1, col + 1)
      empty = "\u2610"

      # starter move when board is clear and pawn hasn't move yet
      moves << [row + 2, col] if piece.has_moved == false && next_square == empty && second_next_square == empty

      # starter move when pawn hasn't move and board is little clear not too clear
      moves << [row + 1, col] if piece.has_moved == false && next_square == empty && second_next_square != empty

      # regular one square movement
      moves << [row + 1, col] if next_square == empty && piece.has_moved == true

      # capture left diagonal
      moves << [row + 1, col - 1] if left_diagonal_piece.color != 'black'

      # capture right diagonal
      moves << [row + 1, col + 1] if right_diagonal_piece.color != 'black'

      moves
    end

    def calculate_white_pawn_moves(row, col, piece, board)
      moves = []
      empty = "\u2610"

      one_forward_row = row - 1
      two_forward_row = row - 2

      # Stop if moving forward is off-board
      return moves if one_forward_row < 0

      one_forward = board.piece_at(one_forward_row, col)

      # one square forward
      if one_forward == empty
        moves << [one_forward_row, col]

        # two squares forward (only if one forward is empty AND pawn hasn't moved)
        if !piece.has_moved && two_forward_row >= 0
          two_forward = board.piece_at(two_forward_row, col)
          moves << [two_forward_row, col] if two_forward == empty
        end
      end

      # captures (only if diagonals are on-board)
      if col - 1 >= 0
        diag_left = board.piece_at(one_forward_row, col - 1)
        moves << [one_forward_row, col - 1] if diag_left != empty && diag_left.color == 'black'
      end

      if col + 1 <= 7 # adjust if your board size differs
        diag_right = board.piece_at(one_forward_row, col + 1)
        moves << [one_forward_row, col + 1] if diag_right != empty && diag_right.color == 'black'
      end

      moves
    end
  end
end
