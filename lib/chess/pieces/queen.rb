# frozen_string_literal: true

require_relative "piece"
# this class has all data related to queen
class Queen < Piece
  BLACK_QUEEN = "\u2655"
  WHITE_QUEEN = "\u265B"

  def to_s
    @color == "black" ? BLACK_QUEEN : WHITE_QUEEN
  end
end
