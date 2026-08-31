# frozen_string_literal: true

require "json"
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

  def to_h
    hash = { type: self.class.to_s, color: @color, row: @row, col: @col, has_moved: @has_moved }
    JSON.dump(hash)
  end
end