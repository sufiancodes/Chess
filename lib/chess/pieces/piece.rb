# frozen_string_literal: true

# This class has all the common data related to pieces
class Piece
  attr_reader :color
  attr_accessor :has_moved, :row, :col

  def initialize(color, row, col, has_moved)
    @color = color
    @row = row
    @col = col
    @has_moved = has_moved
  end

  def enemy_color
    @color == "white" ? "black" : "white"
  end
end
