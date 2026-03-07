class Board
  attr_accessor :board

  EMPTY_SPOT = "\u2610".freeze
  def initialize
    @board = Array.new(8) { Array.new(8) { '' } }
  end

  def to_s; end

  def populate_board
    @board [0] = ["\u2656", "\u2658", "\u2657", "\u2654", "\u2655", "\u2657", "\u2658", "\u2656"]
    @board [1] = ["\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659"]
    @board [6] = ["\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F"]
    @board [7] = ["\u265C", "\u265E", "\u265D", "\u265A", "\u265B", "\u265D", "\u265E", "\u265C"]
  end
end
board = Board.new
pp board.board
board.populate_board
pp board.board




# black_knight = "\u265E"
# white_knight = "\u2658"
# black_squares = "100m"
# white_squares = "107m"
# print "\e[#{black_squares}#{white_knight}\e[0m"
# print "\e[#{white_squares}#{black_knight}\e[0m"
# puts ""

# board = Array.new(8) {Array.new(8)}
# pp board
# # pp board
# board.each do |row|
#   row.each_with_index do |piece, index|
#     puts row
#     return
#   end
# end
