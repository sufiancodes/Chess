# frozen_string_literal: true

# this class contain data related to Rook
class Rook
  attr_reader :color

  BLACK_ROOK = "\u2656"
  WHITE_ROOK = "\u265C"
  def initialize(color, row, col)
    @has_moved = false
    @color = color
    @row = row
    @col = col
  end

  def to_s
    @color == 'white' ? WHITE_ROOK : BLACK_ROOK
  end

  def enemy_color
    @color == 'white' ? BLACK_ROOK : WHITE_ROOK
  end
end

puts "\u265C"