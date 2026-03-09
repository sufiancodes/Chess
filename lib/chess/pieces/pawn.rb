class Pawn
  def initialize(color, position = nil)
    @color = color
    @position = position
  end


end
pawn = Pawn.new('black', 'a1')
puts pawn
