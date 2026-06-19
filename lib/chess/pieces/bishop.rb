# frozen_string_literal: true

class Bishop
  attr_reader :color, :row, :col

  BLACK_BISHOP = "\u2657"
  WHITE_BISHOP = "\u2657"
  def initialize(color, row, col, has_moved)
    @color = color
    @row = row
    @column = col
    @has_moved = false
  end

  def to_s
    @color == "black" ? BLACK_BISHOP : WHITE_BISHOP
  end

  def enemy_color
    @color == "white" ? "black" : "white"
  end
end
