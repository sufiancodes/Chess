# this class have all data related to player class
class Player
  attr_accessor :first_player, :second_player, :turn

  def initialize
    @first_player = nil
    @second_player = nil
    @turn = 0
  end

  def welcome
    puts 'Enter the first player name'
    @first_player = gets.chomp
    puts 'Enter the second player name'
    @second_player = gets.chomp
  end

  def current_player
    if @turn.zero?
      first_player
    else
      second_player
    end
  end

  
end
