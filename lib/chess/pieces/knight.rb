# frozen_string_literal: true

# this class will have all data related to knight
class Knight
  attr_reader :color

  BLACK_KNIGHT = "\u2658"
  WHITE_KNIGHT = "\u265E"
  def initialize(color, row, col)
    @color = color
    @row = row
    @column = col
  end

  def to_s
    @color == 'white' ? WHITE_KNIGHT : BLACK_KNIGHT
  end

  def enemy_color
    @color == 'white' ? BLACK_KNIGHT : WHITE_KNIGHT
  end
end
