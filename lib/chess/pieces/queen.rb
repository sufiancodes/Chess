# frozen_string_literal: true

class Queen
  attr_reader :color, :row, :col

  BLACK_QUEEN = "\u2655"
  WHITE_QUEEN = "\u265B"
  def initialize(color, row, col, has_moved)
    @color = color
    @row = row
    @col = col
    @has_moved = false
  end

  def to_s
    @color == "black" ? BLACK_QUEEN : WHITE_QUEEN
  end

  def enemy_color
    @color == "white" ? "black" : "white"
  end
end
