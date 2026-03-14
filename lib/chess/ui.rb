# frozen_string_literal: true
require_relative 'board'
# this class deals with UI player input etc
class UI
  def display(board)
    @board = board
    puts board
  end
end
board = Board.new
mui = UI.new
mui.display(board)
