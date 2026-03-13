class Pawn
  def initialize(color, position = nil)
    @color = color
    @position = position
  end

  def to_s
    @color == 'white' ? "\u265f" : "\u2659"
  end

  def list_legal_moves(board, row, col)
    # piece = board[row][col]
    # board[row][col] = "\u2610"
    # board[row + 1][col] = piece
    # now just need to implement its rules
    if row
  end
end
pawn = Pawn.new('black', 'a1')
puts pawn

# Forward Only: A pawn moves directly forward one square at a time to an empty square.
# The First-Move Option: If a pawn has not yet moved, it has the option to move two squares forward in a single turn, provided both squares are unoccupied.
# # Blocked Path: If another piece (of either color) is directly in front of a pawn, the pawn cannot move forward and cannot capture that piece.
# Diagonal Capture: Pawns capture by moving one square diagonally forward to a square occupied by an opponent's piece.
# Capturing vs. Moving: A pawn cannot capture a piece directly in front of it.
