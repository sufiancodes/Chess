# frozen_string_literal: true

class Queen
  BLACK_QUEEN = "\u2655"
  WHITE_QUEEN = "\u265B"
  def initialize(color, row, col, has_moved)
    @color = color
    @row = row
    @column = col
    @has_moved = false
  end

  def to_s
    @color == "black" ? BLACK_QUEEN : WHITE_QUEEN
  end

  def enemy_color
    @color == "white" ? "black" : "white"
  end
end
