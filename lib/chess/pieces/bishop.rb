# frozen_string_literal: true

require_relative "piece"
class Bishop < Piece
  BLACK_BISHOP = "\u2657"
  WHITE_BISHOP = "\u2657"

  def to_s
    @color == "black" ? BLACK_BISHOP : WHITE_BISHOP
  end
end
