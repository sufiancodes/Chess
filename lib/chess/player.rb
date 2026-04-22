class Player
  
  def initialize
    @first_player = first_player
    @second_player = second_player
  end

  def welcome
    puts 'Enter the first player name'
    @first_player = gets.chomp
    puts 'Enter the second player name'
    @second_player = gets.chomp
  end
end
