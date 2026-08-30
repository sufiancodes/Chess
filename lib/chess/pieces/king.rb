# frozen_string_literal: true

require_relative "piece"
class King < Piece
  WHITE_KING = "\u265A"
  BLACK_KING = "\u2654"

  def to_s
    @color == "black" ? BLACK_KING : WHITE_KING
  end
end
