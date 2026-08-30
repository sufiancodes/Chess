# frozen_string_literal: true
require_relative "piece"
# this class will have all data related to knight
class Knight
  BLACK_KNIGHT = "\u2658"
  WHITE_KNIGHT = "\u265E"

  def to_s
    @color == "white" ? WHITE_KNIGHT : BLACK_KNIGHT
  end
end
