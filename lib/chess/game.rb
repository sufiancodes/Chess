# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
# This class will have logic related to game
class Game
  attr_accessor :player

  def initialize
    @board = Board.new
    @player = Player.new
    @current_name = nil
  end

  def translate_user_input(position)
    col = { 'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7 }
    row = { '1' => 7, '2' => 6, '3' => 5, '4' => 4, '5' => 3, '6' => 2, '7' => 1, '8' => 0 }
    p create_useable_array(position, col, row)
  end

  def translate_computer_input(array)
    col_map = %w[a b c d e f g h]
    row_map = %w[8 7 6 5 4 3 2 1]
    row_index, col_index = array
    (col_map[col_index] + row_map[row_index]).to_s
  end

  def play
    @player.welcome
    loop do
      puts @board
      puts "#{player.current_player}: Please chose the piece you wish to move"
      input = gets.chomp
      p input
      array = translate_user_input(input)
      p array
      moves = @board.possible_moves_from(array)
      if moves.empty?
        puts 'no possible move available'
        redo
      end
      puts 'Now select the move from below you wish to play'
      moves.each { |element| puts translate_computer_input(element) }
      ip = gets.chomp
      iii = translate_user_input(ip)
      @board.move_piece(array, iii)
      puts @board
      player.switch_player!
    end
  end

  private

  def create_useable_array(position, col_alphabets, row_numbers)
    pos = position.split('')
    column = pos[0]
    row = pos[1]
    result = [row_numbers[row], col_alphabets[column]]
  end
end

game = Game.new
game.play
