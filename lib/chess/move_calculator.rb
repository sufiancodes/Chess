# frozen_string_literal: true

# this module calculate moves for all the pieces
module MoveCalculator
  def self.legal_moves(row, col, board)
    piece = board.piece_at(row, col)
    color = piece.color

    case piece
    when Pawn
      calculate_pawn_moves(row, col, color, piece)
      # when Rook
      #   calculate_rook_moves(position, board, color)
    end
  end

  def self.calculate_pawn_moves(row, col, color, piece)
    if color == 'white'
      calculate_white_pawn_move(row, col, piece)
    elsif color == 'black'
      calculate_pawn_moves(row, col, piece)
    end
  end
end
  #  so here even in this method i can create cases weather its black or white one and then run appropriate case
  #   moves = []
  #   next_square = board.piece_at(row + 1, col)
  #   second_next_square = board.piece_at(row + 2, col)
  #   right_diagonal = board.piece_at(row + 1, col + 1)
  #   left_diagonal = board.piece_at(row + 1, col - 1)
  #   if color == 'black' && piece.has_move == false && next_square == "\u2610" && second_next_square == "\u2610"
  #     moves << [[row + 2] [col]
  #   end
  #   if color == 'black' && piece.has_move == false && next_square == "\u2610" && second_next_square != "\u2610"
  #     moves << [[row + 1], [col]]
  #   end
  #   if color == 'black' && next_square == "\u2610"
  #     moves << [[row + 1], [col]]
  #   end
  #   if right_diagonal != "\u2610"
  #     moves << [[row + 1], [col + 1]]
  #   end
  #   if left_diagonal != "\u2610"
  #     moves << [[row + 1], [col - 1]]
  #   end
  #   p moves