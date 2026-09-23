# frozen_string_literal: true

# this class deals with rule of game

require_relative "move_calculator"
class RuleEngine
  include MoveCalculator

  def check_mate?(king, board)
    return false unless MoveCalculator.check?(king, board)

    MoveCalculator.possible_moves_from([king.row, king.col], board).empty? && !can_escape?(king, board)
  end

  def valid_moves(king, board)
    saveable_squares = []
    collected_pieces = board.collect_all_pieces(king.color)
    own_pieces = collected_pieces.reject { |piece| piece.class == King }
    own_pieces.each { |piece| saveable_squares.push(MoveCalculator.possible_moves_from([piece.row, piece.col], board)) }
    saveable_squares.flatten(1)
  end

  def can_escape?(king, board)
    board.collect_all_pieces(king.color)
      .reject { |piece| piece.is_a?(King) }
      .any? { |piece| legal_moves_for_piece(piece, board).any? }
  end

  def legal_moves_for_piece(piece, board)
    pseudo_legal_moves = MoveCalculator.possible_moves_from([piece.row, piece.col], board)
    pseudo_legal_moves.select { |move| legal_after_move?(piece, move, board) }
  end

  def pawn_promotion_possible?(pawn)
    # condition is simple if it has reached other side of board promote it
    return true if pawn.color == "black" && pawn.row == 7

    true if pawn.color == "white" && pawn.row == 0
  end

  private

  def legal_after_move?(piece, move, board)
    dummy_board = Marshal.load(Marshal.dump(board))
    dummy_piece = dummy_board.piece_at(piece.row, piece.col)

    if castling_move?(move)
      dummy_board.move_two_pieces([dummy_piece.row, dummy_piece.col], move[0, 2], move[2, 2])
    else
      dummy_board.move_piece([dummy_piece.row, dummy_piece.col], move)
    end

    own_king = dummy_board.find_king(piece.color)
    !MoveCalculator.check?(own_king, dummy_board)
  end

  def castling_move?(move)
    move.length == 4
  end
end
