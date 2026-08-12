# frozen_string_literal: true

# this class deals with rule of game

require_relative "move_calculator"
class RuleEngine
  include MoveCalculator

  def possible_moves_from(array, board)
    MoveCalculator.legal_moves(array[0], array[1], board)
  end

  def square_under_attack?(row, col, enemy_color, board)
    moves = []
    enemies = board.collect_all_pieces(enemy_color)
    enemies.each do |enemy|
      if enemy.instance_of?(Pawn)
        moves << pawn_attack_moves(enemy)
      elsif enemy.instance_of?(King)
        moves << king_attack_moves(enemy)
      else
        moves.push(possible_moves_from([enemy.row, enemy.col], board))
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

  def check?(king, board)
    square_under_attack?(king.row, king.col, king.enemy_color, board)
  end

  def check_mate?(king, board)
    check?(king, board) && possible_moves_from([king.row, king.col], board).empty? && !can_escape?(king, board)
  end

  def valid_moves(king, board)
    saveable_squares = []
    collected_pieces = board.collect_all_pieces(king.color)
    own_pieces = collected_pieces.reject { |piece| piece.class == King }
    own_pieces.each { |piece| saveable_squares.push(possible_moves_from([piece.row, piece.col], board)) }
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
end
