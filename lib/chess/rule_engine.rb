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
  
end
