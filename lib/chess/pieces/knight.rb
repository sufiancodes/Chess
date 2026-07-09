# frozen_string_literal: true

# this class will have all data related to knight
class Knight
  attr_reader :color
  attr_accessor :has_moved, :row, :col


  BLACK_KNIGHT = "\u2658"
  WHITE_KNIGHT = "\u265E"
  def initialize(color, row, col)
    @row = row
    @col = col
    @color = color
  end

  def to_s
    @color == "white" ? WHITE_KNIGHT : BLACK_KNIGHT
  end

  def enemy_color
    @color == "white" ? "black" : "white"
  end
end
