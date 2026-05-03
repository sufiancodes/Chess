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
      when Knight
        calculate_knight_moves(row, col, color, piece, board)
      end
    end

    def calculate_pawn_moves(row, col, color, piece, board)
      if color == 'black'
        calculate_black_pawn_moves(row, col, piece, board)
      else
        calculate_white_pawn_moves(row, col, piece, board)
      end
    end

    def calculate_knight_moves(row, col, color, piece, board)
      if color == 'black'
        calculate_black_knight_moves(row, col, piece, board)
      else
        calculate_white_knight_moves(row, col, piece, board)
      end
    end

    private

    # For Black and White Knight move calculation

    # For Black and White Pawn move calculation
    def calculate_black_pawn_moves(row, col, piece, board)
      moves = []
      empty = "\u2610"

      one_forward_row = row + 1
      two_forward_row = row + 2

      # stop if moving forward goes of board
      return moves if one_forward_row > 7

      one_forward = board.piece_at(one_forward_row, col)

      # one square move
      if one_forward == empty
        moves << [one_forward_row, col]

        # two squares forward (only if one forward is empty AND pawn hasn't moved)
        if !piece.has_moved && two_forward_row <= 7
          two_forward = board.piece_at(two_forward_row, col)
          moves << [two_forward_row, col] if two_forward == empty
        end
      end

      if col - 1 >= 0
        diag_right = board.piece_at(one_forward_row, col - 1)
        moves << [one_forward_row, col - 1] if diag_right != empty && diag_right.color == 'white'
      end

      if col + 1 <= 7 # adjust if your board size differs
        diag_left = board.piece_at(one_forward_row, col + 1)
        moves << [one_forward_row, col + 1] if diag_left != empty && diag_left.color == 'white'
      end

      moves
    end

    def calculate_white_pawn_moves(row, col, piece, board)
      moves = []
      empty = "\u2610"

      one_forward_row = row - 1
      two_forward_row = row - 2

      # Stop if moving forward is off-board
      return moves if one_forward_row.negative?

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
        diag_right = board.piece_at(one_forward_row, col - 1)
        moves << [one_forward_row, col - 1] if diag_right != empty && diag_right.color == 'black'
      end

      if col + 1 <= 7 # adjust if your board size differs
        diag_right = board.piece_at(one_forward_row, col + 1)
        moves << [one_forward_row, col + 1] if diag_right != empty && diag_right.color == 'black'
      end

      moves
    end
  end
end
