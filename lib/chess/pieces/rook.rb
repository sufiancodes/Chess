# frozen_string_literal: true

require_relative "piece"
# this class contain data related to Rook
class Rook < Piece
  BLACK_ROOK = "\u2656"
  WHITE_ROOK = "\u265C"

  def to_s
    @color == "white" ? WHITE_ROOK : BLACK_ROOK
  end
end
