# frozen_string_literal: true

# this class deals with rule of game

require_relative "move_calculator"
class RuleEngine
  include MoveCalculator

  def check_mate?(king, board)
    MoveCalculator.check?(king, board) && MoveCalculator.possible_moves_from([king.row, king.col], board).empty? && !can_escape?(king, board)
  end

  def valid_moves(king, board)
    saveable_squares = []
    collected_pieces = board.collect_all_pieces(king.color)
    own_pieces = collected_pieces.reject { |piece| piece.class == King }
    own_pieces.each { |piece| saveable_squares.push(MoveCalculator.possible_moves_from([piece.row, piece.col], board)) }
    saveable_squares.flatten(1)
  end

  def can_escape?(king, board)
    dummy_board = Marshal.load(Marshal.dump(board))
    dummy_king = dummy_board.find_king(king.color)
    collected_move = valid_moves(dummy_king, dummy_board)
    collected_move.each do |row, col|
      original_state = dummy_board.board[row][col]
      dummy_board.board[row][col] = Knight.new(dummy_king.color, row, col)
      return true if MoveCalculator.check?(dummy_king, dummy_board) == false

      dummy_board.board[row][col] = original_state
    end
    false
  end

  def pawn_promotion_possible?(pawn)
    # condition is simple if it has reached other side of board promote it
    return true if pawn.color == "black" && pawn.row == 7
    return true if pawn.color == "white" && pawn.row == 0
  end
end
