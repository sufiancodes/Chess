# frozen_string_literal: true

require_relative "../lib/chess/rule_engine"
require_relative "../lib/chess/board"

RSpec.describe(RuleEngine) do
  subject(:rule_engine) { described_class.new }

  def clear_board(board)
    board.board = Array.new(8) { Array.new(8, Board::EMPTY_SPOT) }
  end

  def place_piece(board, piece)
    board.board[piece.row][piece.col] = piece
  end

  it "does not report checkmate when a check can be blocked" do
    board = Board.new
    clear_board(board)

    white_king = King.new("white", 7, 4, false)
    white_rook = Rook.new("white", 6, 0, false)
    black_rook = Rook.new("black", 0, 4, false)
    black_king = King.new("black", 0, 0, false)

    [white_king, white_rook, black_rook, black_king].each { |piece| place_piece(board, piece) }

    expect(MoveCalculator.check?(white_king, board)).to(be(true))
    expect(rule_engine.check_mate?(white_king, board)).to(be(false))
  end

  it "does not report checkmate when a checking piece can be captured" do
    board = Board.new
    clear_board(board)

    white_king = King.new("white", 7, 4, false)
    white_queen = Queen.new("white", 7, 3, false)
    black_rook = Rook.new("black", 6, 4, false)
    black_king = King.new("black", 0, 0, false)

    [white_king, white_queen, black_rook, black_king].each { |piece| place_piece(board, piece) }

    expect(MoveCalculator.check?(white_king, board)).to(be(true))
    expect(rule_engine.check_mate?(white_king, board)).to(be(false))
  end

  it "does not report checkmate when the king can escape" do
    board = Board.new
    clear_board(board)

    white_king = King.new("white", 7, 4, false)
    black_rook = Rook.new("black", 0, 4, false)
    black_king = King.new("black", 0, 0, false)

    [white_king, black_rook, black_king].each { |piece| place_piece(board, piece) }

    expect(MoveCalculator.check?(white_king, board)).to(be(true))
    expect(rule_engine.check_mate?(white_king, board)).to(be(false))
  end

  it "reports checkmate when side is in check and has no legal moves" do
    board = Board.new

    board.move_piece([6, 5], [5, 5])
    board.move_piece([1, 4], [3, 4])
    board.move_piece([6, 6], [4, 6])
    board.move_piece([0, 3], [4, 7])

    white_king = board.find_king("white")

    expect(MoveCalculator.check?(white_king, board)).to(be(true))
    expect(rule_engine.check_mate?(white_king, board)).to(be(true))
  end

  it "allows only king moves as legal responses to a double check" do
    board = Board.new
    clear_board(board)

    white_king = King.new("white", 7, 4, false)
    white_rook = Rook.new("white", 6, 0, false)
    black_rook = Rook.new("black", 0, 4, false)
    black_bishop = Bishop.new("black", 4, 1, false)
    black_king = King.new("black", 0, 0, false)

    [white_king, white_rook, black_rook, black_bishop, black_king].each { |piece| place_piece(board, piece) }

    expect(MoveCalculator.check?(white_king, board)).to(be(true))
    expect(rule_engine.legal_moves_for_piece(white_rook, board)).to(eq([]))
  end

  it "filters out moves that leave the king in check" do
    board = Board.new
    clear_board(board)

    white_king = King.new("white", 7, 4, false)
    white_rook = Rook.new("white", 6, 4, false)
    black_rook = Rook.new("black", 0, 4, false)
    black_king = King.new("black", 0, 0, false)

    [white_king, white_rook, black_rook, black_king].each { |piece| place_piece(board, piece) }

    expect(rule_engine.legal_moves_for_piece(white_rook, board)).not_to(include([6, 3], [6, 5]))
  end
end
