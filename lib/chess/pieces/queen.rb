
class Queen

  BLACK_QUEEN = "\u2655"
  WHITE_QUEEN = "\u265B"
  def initialize(color, row, col, has_moved)
    @color = color
    @row = row
    @column = col
    @has_moved = false
  end
end
