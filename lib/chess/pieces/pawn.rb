# frozen_string_literal: true

# this class have the data related to pawn
class Pawn
  WHITE_PAWN = "\u265f"
  BLACK_PAWN = "\u2659"

  attr_reader :color
  attr_accessor :has_moved, :row, :col

  def initialize(color, row, col, has_moved)
    @color = color
    @row = row
    @col = col
    @has_moved = false
  end

  def to_s
    @color == "white" ? WHITE_PAWN : BLACK_PAWN
  end

  def enemy_color
    @color == "white" ? "black" : "white"
  end
end
