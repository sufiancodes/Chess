# frozen_string_literal: true

require_relative "../lib/chess/board"

RSpec.describe(Board) do
  subject(:board) { described_class.new }

  describe "#initialize" do
    it "creates an eight-by-eight board" do
      expect(board.board.length).to(eq(8))
      expect(board.board.all? { |row| row.length == 8 }).to(be(true))
    end

    it "populates the board with the black pieces" do
      expect(board.piece_at(0, 0)).to(be_a(Rook))
      expect(board.piece_at(0, 1)).to(be_a(Knight))
      expect(board.piece_at(0, 2)).to(be_a(Bishop))
      expect(board.piece_at(0, 3)).to(be_a(Queen))
      expect(board.piece_at(0, 4)).to(be_a(King))
      expect(board.piece_at(1, 0)).to(be_a(Pawn))
    end

    it "populates the board with the white pieces" do
      expect(board.piece_at(7, 0)).to(be_a(Rook))
      expect(board.piece_at(7, 1)).to(be_a(Knight))
      expect(board.piece_at(7, 2)).to(be_a(Bishop))
      expect(board.piece_at(7, 3)).to(be_a(Queen))
      expect(board.piece_at(7, 4)).to(be_a(King))
      expect(board.piece_at(6, 0)).to(be_a(Pawn))
    end

    it "leaves the middle rows empty" do
      expect(board.row(2)).to(all(eq(Board::EMPTY_SPOT)))
      expect(board.row(3)).to(all(eq(Board::EMPTY_SPOT)))
      expect(board.row(4)).to(all(eq(Board::EMPTY_SPOT)))
      expect(board.row(5)).to(all(eq(Board::EMPTY_SPOT)))
    end
  end

  describe "#piece_at" do
    it "returns the piece at the given position" do
      expect(board.piece_at(7, 4)).to(be_a(King))
      expect(board.piece_at(7, 4).color).to(eq("white"))
    end

    it "returns the empty spot marker when the position is empty" do
      expect(board.piece_at(3, 3)).to(eq(Board::EMPTY_SPOT))
    end
  end

  describe "#row" do
    it "returns all values from the requested row" do
      expect(board.row(6)).to(all(be_a(Pawn)))
      expect(board.row(6).map(&:color)).to(all(eq("white")))
    end
  end

  describe "#column" do
    it "returns all values from the requested column" do
      column = board.column(0)

      expect(column[0]).to(be_a(Rook))
      expect(column[1]).to(be_a(Pawn))
      expect(column[2]).to(eq(Board::EMPTY_SPOT))
      expect(column[6]).to(be_a(Pawn))
      expect(column[7]).to(be_a(Rook))
    end
  end

  describe "#empty_at?" do
    it "returns true when the position is empty" do
      expect(board.empty_at?(3, 3)).to(be(true))
    end

    it "returns false when the position contains a piece" do
      expect(board.empty_at?(7, 4)).to(be(false))
    end
  end

  describe "#enemy_at?" do
    it "returns true when the position contains an enemy piece" do
      expect(board.enemy_at?("white", 0, 4)).to(be(true))
    end

    it "returns false when the position contains a friendly piece" do
      expect(board.enemy_at?("white", 7, 4)).to(be(false))
    end

    it "returns false when the position is empty" do
      expect(board.enemy_at?("white", 3, 3)).to(be(false))
    end
  end

  describe "#friendly_at?" do
    it "returns true when the position contains a friendly piece" do
      expect(board.friendly_at?("white", 7, 4)).to(be(true))
    end
    it "returns false when the position is empty" do
      expect(board.friendly_at?("white", 3, 3)).to(be(false))
    end
  end

  describe "#move_piece" do
    it "moves a piece to the destination position" do
      board.move_piece([6, 0], [5, 0])

      expect(board.piece_at(5, 0)).to(be_a(Pawn))
      expect(board.piece_at(5, 0).color).to(eq("white"))
      expect(board.piece_at(6, 0)).to(eq(Board::EMPTY_SPOT))
    end

    it "updates the piece coordinates" do
      board.move_piece([6, 0], [5, 0])

      pawn = board.piece_at(5, 0)

      expect(pawn.row).to(eq(5))
      expect(pawn.col).to(eq(0))
    end

    it "marks a pawn as having moved" do
      pawn = board.piece_at(6, 0)

      expect(pawn.has_moved).to(be(false))

      board.move_piece([6, 0], [5, 0])

      expect(pawn.has_moved).to(be(true))
    end

    it "marks a rook as having moved" do
      rook = board.piece_at(7, 0)

      expect(rook.has_moved).to(be(false))

      board.move_piece([7, 0], [6, 0])

      expect(rook.has_moved).to(be(true))
    end

    it "marks a king as having moved" do
      king = board.piece_at(7, 4)

      expect(king.has_moved).to(be(false))

      board.move_piece([7, 4], [6, 4])

      expect(king.has_moved).to(be(true))
    end
  end

  describe "#move_two_pieces" do
    it "moves the king and rook during kingside castling" do
      board.move_two_pieces([7, 4], [7, 6], [7, 5])

      expect(board.piece_at(7, 6)).to(be_a(King))
      expect(board.piece_at(7, 5)).to(be_a(Rook))
      expect(board.piece_at(7, 4)).to(eq(Board::EMPTY_SPOT))
      expect(board.piece_at(7, 7)).to(eq(Board::EMPTY_SPOT))
    end

    it "moves the king and rook during queenside castling" do
      board.move_two_pieces([7, 4], [7, 2], [7, 3])

      expect(board.piece_at(7, 2)).to(be_a(King))
      expect(board.piece_at(7, 3)).to(be_a(Rook))
      expect(board.piece_at(7, 4)).to(eq(Board::EMPTY_SPOT))
      expect(board.piece_at(7, 0)).to(eq(Board::EMPTY_SPOT))
    end
  end

  describe "#promote_pawn" do
    it "replaces the pawn with a queen" do
      pawn = Pawn.new("white", 0, 0, false)
      board.board[0][0] = pawn

      board.promote_pawn(pawn)

      promoted_piece = board.piece_at(0, 0)

      expect(promoted_piece).to(be_a(Queen))
      expect(promoted_piece.color).to(eq("white"))
      expect(promoted_piece.row).to(eq(0))
      expect(promoted_piece.col).to(eq(0))
    end

    it "promotes a black pawn to a black queen" do
      pawn = Pawn.new("black", 7, 7, false)
      board.board[7][7] = pawn

      board.promote_pawn(pawn)

      expect(board.piece_at(7, 7)).to(be_a(Queen))
      expect(board.piece_at(7, 7).color).to(eq("black"))
    end
  end

  describe "#find_rook" do
    it "finds the white kingside rook" do
      expect(board.find_rook([7, 4], [7, 6])).to(eq([7, 7]))
    end

    it "finds the white queenside rook" do
      expect(board.find_rook([7, 4], [7, 2])).to(eq([7, 0]))
    end

    it "finds the black kingside rook" do
      expect(board.find_rook([0, 4], [0, 6])).to(eq([0, 7]))
    end

    it "finds the black queenside rook" do
      expect(board.find_rook([0, 4], [0, 2])).to(eq([0, 0]))
    end
  end

  describe "#find_king" do
    it "returns the white king" do
      king = board.find_king("white")

      expect(king).to(be_a(King))
      expect(king.color).to(eq("white"))
      expect(king.row).to(eq(7))
      expect(king.col).to(eq(4))
    end

    it "returns the black king" do
      king = board.find_king("black")

      expect(king).to(be_a(King))
      expect(king.color).to(eq("black"))
      expect(king.row).to(eq(0))
      expect(king.col).to(eq(4))
    end
  end

  describe "#collect_all_pieces" do
    it "returns all white pieces" do
      white_pieces = board.collect_all_pieces("white")

      expect(white_pieces.length).to(eq(16))
      expect(white_pieces).to(all(
        satisfy { |piece| piece.color == "white" },
      ))
    end

    it "returns all black pieces" do
      black_pieces = board.collect_all_pieces("black")

      expect(black_pieces.length).to(eq(16))
      expect(black_pieces).to(all(
        satisfy { |piece| piece.color == "black" },
      ))
    end

    it "does not include empty positions" do
      pieces = board.collect_all_pieces("white")

      expect(pieces).not_to(include(Board::EMPTY_SPOT))
    end
  end
end
