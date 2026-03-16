class Pawn
  WHITE_PAWN = "\u265f".freeze
  BLACK_PAWN = "\u2659".freeze

  attr_reader :color

  def initialize(color, position = nil)
    @color = color
    @position = position
  end

  def to_s
    @color == 'white' ? WHITE_PAWN : BLACK_PAWN
  end

  def list_legal_moves(board, row, col)
    # I still need to catch it at boundaries
    if color == 'black' && row == 1 && !board[row + 1] == "\u2610"
      "#{board[row + 1][col]} or #{board[row + 2][col]}"
    elsif color == 'white' && row == 6 && !board[row - 1] == "\u2610"
      "#{board[row - 1][col]} or #{board[row - 2][col]}"
    elsif color == 'black' && !board[row + 1] == "\u2610"
      'cant move'
    elsif color == 'white' && !board[row - 1] == "\u2610"
      'cant move'
    elsif color == 'black' && (!board[row + 1][col + 1] == "\u2610" || !board[row + 1][col - 1] == "\u2610")
      if !board[row + 1][col + 1] == "\u2610" && !board[row + 1][col - 1] == "\u2610"
        "#{board[row + 1][col + 1]} or #{board[row + 1][col - 1]}"
      elsif !board[row + 1][col + 1] == "\u2610"
        "#{board[row + 1][col + 1]}"
      elsif !board[row + 1][col - 1] == "\u2610"
        "#{board[row + 1][col - 1]}"
      end
    elsif color == 'white' && (!board[row - 1][col - 1] == "\u2610" || !board[row - 1][col + 1] == "\u2610")
      if !board[row - 1][col + 1] == "\u2610" && !board[row - 1][col - 1] == "\u2610"
        "#{board[row - 1][col + 1]} or #{board[row - 1][col - 1]}"
      elsif !board[row - 1][col + 1] == "\u2610"
        "#{board[row - 1][col + 1]}"
      elsif !board[row - 1][col - 1] == "\u2610"
        "#{board[row - 1][col - 1]}"
      end
    elsif color == 'black' && board[row + 1] == "\u2610"
      "#{board[row + 1]}"
    elsif color == 'white' && board[row - 1] == "\u2610"
      "#{board[row - 1]}"
    end
    # now just movement of one is need to be Implement but that movement is only possible when the spot is ☐ else no but yes it can capture diagonal
  end
end

# pawn = Pawn.new('black', 'a1')
# puts pawn

# Forward Only: A pawn moves directly forward one square at a time to an empty square.
# The First-Move Option: If a pawn has not yet moved, it has the option to move two squares forward in a single turn, provided both squares are unoccupied.
# # Blocked Path: If another piece (of either color) is directly in front of a pawn, the pawn cannot move forward and cannot capture that piece.
# Diagonal Capture: Pawns capture by moving one square diagonally forward to a square occupied by an opponent's piece.
# Capturing vs. Moving: A pawn cannot capture a piece directly in front of it.
