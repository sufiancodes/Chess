# frozen_string_literal: true

# this class will have all data related to knight
class Knight
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
end
