# frozen_string_literal: true

require "json"
require_relative "pieces/piece"
require_relative "board"
require_relative "player"
require_relative "ui"
require_relative "rule_engine"
require_relative "move_calculator"
# This class will have logic related to game
class Game
  attr_accessor :player

  def initialize
    @board = Board.new
    @player = Player.new
    @ui = UI.new
    @rule_engine = RuleEngine.new
  end

  def play
    @player.welcome
    @ui.display(@board.board)
    loop do
      # prompting user to select the piece and processing user input
      puts "#{player.current_player}: Please chose the piece you wish to move"
      input = gets.chomp

      # load, save and quit functionality
      save_serialize_data if input == "save"
      redo if input == "save"
      load_saved_data if input == "load"
      redo if input == "load"
      break if input == "quit"

      source = @ui.translate_user_input(input)
      redo if @board.empty_at?(source[0], source[1])
      selected_piece = @board.piece_at(source[0], source[1])
      if selected_piece.color != current_player_color
        puts "Please choose your own piece"
        redo
      end

      # listing moves
      possible_moves = list_moves(selected_piece)
      if possible_moves.nil?
        puts "No possible moves here"
        redo
      else
        possible_moves
        puts " "
      end

      # Taking user selected move and moving piece on board
      selected_move = gets.chomp
      if selected_move.length == 4
        castling_positions = @ui.translate_castling_input(selected_move)
        castling_move = castling_positions.flatten
        redo unless possible_moves.include?(castling_move)

        @board.move_two_pieces([selected_piece.row, selected_piece.col], castling_positions[0], castling_positions[1])
        destination = castling_positions[0]
      else
        destination = @ui.translate_user_input(selected_move)
        redo unless possible_moves.include?(destination)

        @board.move_piece(source, destination)
      end

      # pawn promotion
      @board.promote_pawn(selected_piece) if @rule_engine.pawn_promotion_possible?(selected_piece)

      # finding enemy king
      piece = @board.piece_at(destination[0], destination[1])
      enemy_king = @board.find_king(piece.enemy_color)

      # showing board and switching player
      @ui.display(@board.board)

      # stop game if its checkmate or 
      break if @rule_engine.check_mate?(enemy_king, @board)

      player.switch_player!
    end
  end

  private

  def list_moves(piece)
    moves = @rule_engine.legal_moves_for_piece(piece, @board)
    if moves.empty?
      nil
    else
      # showing user possible moves
      puts "Now select the move from below you wish to play"
      moves.each { |element| print(@ui.translate_computer_input(element) + " ") }
      moves
    end
  end

  def current_player_color
    @player.turn.zero? ? "white" : "black"
  end

  def save_data
    game_state = @board.board.map do |row|
      row.map do |square|
        square.is_a?(Piece) ? square.to_h : square.to_s
      end
    end
    game_state
  end

  def save_serialize_data
    puts "Write the name of file"
    name = gets.chomp
    File.write("loads/#{name}.json", JSON.dump(save_data))
  end

  def from_json(name)
    JSON.parse(File.read("loads/#{name}.json"))
  end

  def load_saved_data
    puts "Type in name of the file"
    name_of_file = gets.chomp
    data = from_json(name_of_file)
    @board.board = data.map do |row|
      row.map do |square|
        if square.is_a?(Hash)
          klass = Object.const_get(square["type"])
          klass.new(square["color"], square["row"], square["col"], square["has_moved"])
        else
          "☐"
        end
      end
    end
  end
end
