# frozen_string_literal: true

# this class deals with rule of game

require_relative "move_calculator"
class RuleEngine
  include MoveCalculator

  def check?(king, board)
    MoveCalculator.square_under_attack?(king.row, king.col, king.enemy_color, board)
  end

  def check_mate?(king, board)
    check?(king, board) && MoveCalculator.possible_moves_from([king.row, king.col], board).empty? && !can_escape?(king, board)
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
      return true if check?(dummy_king, dummy_board) == false

      dummy_board.board[row][col] = original_state
    end
    false
  end

  def queen_side_castle_possible?(king, board)
    rook = board.piece_at(king.row, king.col - 4)
    return false if board.piece_at(king.row, king.col - 4).class != Rook
    return false if king.has_moved == true || rook.has_moved == true
    return false if check?(king, board)
    return false if MoveCalculator.square_under_attack?(king.row, king.col - 1, king.enemy_color, board) || board.piece_at(king.row, king.col - 1) != Board::EMPTY_SPOT
    return false if MoveCalculator.square_under_attack?(king.row, king.col - 2, king.enemy_color, board) || board.piece_at(king.row, king.col - 2) != Board::EMPTY_SPOT
    return false if MoveCalculator.square_under_attack?(king.row, king.col - 3, king.enemy_color, board) || board.piece_at(king.row, king.col - 3) != Board::EMPTY_SPOT

    true
  end
end
