# frozen_string_literal: true

# this class contain data related to Rook
class Rook
  attr_reader :color
  attr_accessor :has_moved, :row, :col

  BLACK_ROOK = "\u2656"
  WHITE_ROOK = "\u265C"
  def initialize(color, row, col, has_moved)
    @color = color
    @row = row
    @col = col
    @has_moved = false
  end

  def to_s
    @color == "white" ? WHITE_ROOK : BLACK_ROOK
  end

  def enemy_color
    @color == "white" ? "black" : "white"
  end
end
