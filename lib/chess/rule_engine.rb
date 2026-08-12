# frozen_string_literal: true

# this class deals with rule of game

require_relative "move_calculator"
require_relative "board"
class RuleEngine
  include MoveCalculator

  def initialize
    @board = Board.new
  end

  def possible_moves_from(array)
    MoveCalculator.legal_moves(array[0], array[1], @board)
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
    # rule_engine
    moves = []
    direction = enemy.color == "white" ? -1 : +1
    [-1, + 1].each do |delta|
      column = enemy.col + delta
      moves.push([enemy.row + direction, column]) if column.between?(0, 7) && (enemy.row + direction).between?(0, 7)
    end
    moves
  end

  def king_attack_moves(king)
    # rule_engine
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

  def check?(king)
    # rule_engine
    square_under_attack?(king.row, king.col, king.enemy_color)
  end

  def check_mate?(king)
    # rule_engine
    check?(king) && @rule_engine.possible_moves_from([king.row, king.col]).empty? && !can_escape?(king)
  end
end
