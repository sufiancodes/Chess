# frozen_string_literal: true

require_relative "board"
require_relative "player"
require_relative "ui"
# This class will have logic related to game
class Game
  attr_accessor :player

  def initialize
    @board = Board.new
    @player = Player.new
    @ui = UI.new
    @current_name = nil
  end

  def play
    @player.welcome
    loop do
      puts @board
      puts "#{player.current_player}: Please chose the piece you wish to move"
      input = gets.chomp

      # translating stage
      array = translate_user_input(input)
      moves = @board.possible_moves_from(array)

      # re prompting when no move available
      if moves.empty?
        puts "no possible move available"
        redo
      end
      puts "Now select the move from below you wish to play"

      # showing user possible moves
      moves.each { |element| print translate_computer_input(element) + " "  }

      # processing user move
      ip = gets.chomp
      destination = translate_user_input(ip)
      @board.move_piece(array, destination)

      # finding enemy king
      piece = @board.piece_at(destination[0], destination[1])
      enemy_king = @board.find_enemy_king(piece.enemy_color)

      # showing board and switching player
      puts @board
      # stop game if its checkmate
      break if @board.check_mate?(enemy_king)

      player.switch_player!
    end
  end
end

game = Game.new
game.play
