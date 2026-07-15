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
    @ui.display(@board.board)
    loop do
      puts "#{player.current_player}: Please chose the piece you wish to move"
      input = gets.chomp
      source = @ui.translate_user_input(input)

      # listing moves
      possible_moves = list_moves(source)
      if possible_moves.nil?
        puts "No possible moves here"
        redo
      else
        possible_moves
        puts " "
      end

      take_move = gets.chomp
      destination = @ui.translate_user_input(take_move)
      @board.move_piece(source, destination)

      # finding enemy king
      piece = @board.piece_at(destination[0], destination[1])
      enemy_king = @board.find_enemy_king(piece.enemy_color)

      # showing board and switching player
      @ui.display(@board.board)

      # stop game if its checkmate
      break if @board.check_mate?(enemy_king)

      player.switch_player!
    end
  end

  def list_moves(source)
    moves = @board.possible_moves_from(source)
    if moves.empty?
      nil
    else
      # showing user possible moves
      puts "Now select the move from below you wish to play"
      moves.each { |element| print(@ui.translate_computer_input(element) + " ") }
    end
  end
end

game = Game.new
game.play
