# frozen_string_literal: true

require_relative "piece"
# this class have the data related to pawn
class Pawn < Piece
  WHITE_PAWN = "\u265f"
  BLACK_PAWN = "\u2659"

  def to_s
    @color == "white" ? WHITE_PAWN : BLACK_PAWN
  end
end
