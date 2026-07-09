# frozen_string_literal: true

class King
  attr_reader :color
  attr_accessor :has_moved, :row, :col

  WHITE_KING = "\u265A"
  BLACK_KING = "\u2654"
  def initialize(color, row, col, has_moved)
    @color = color
    @row = row
    @col = col
    @has_moved = false
  end

  def to_s
    @color == "black" ? BLACK_KING : WHITE_KING
  end

  def enemy_color
    @color == "white" ? "black" : "white"
  end
end
