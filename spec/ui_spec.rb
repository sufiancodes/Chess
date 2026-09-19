# frozen_string_literal: true

require_relative "../lib/chess/ui"

RSpec.describe(UI) do
  subject(:ui) { described_class.new }

  describe "#display" do
    let(:board) do
      Array.new(8) { Array.new(8, ".") }
    end

    it "prints the board with row numbers and column letters" do
      expected_output = <<~BOARD
        8 . . . . . . . .
        7 . . . . . . . .
        6 . . . . . . . .
        5 . . . . . . . .
        4 . . . . . . . .
        3 . . . . . . . .
        2 . . . . . . . .
        1 . . . . . . . .
          a b c d e f g h
      BOARD

      expect { ui.display(board) }
        .to(output(expected_output).to_stdout)
    end

    it "prints the actual board contents" do
      board = [
        ["r", "n", "b", "q", "k", "b", "n", "r"],
        ["p", "p", "p", "p", "p", "p", "p", "p"],
        [".", ".", ".", ".", ".", ".", ".", "."],
        [".", ".", ".", ".", ".", ".", ".", "."],
        [".", ".", ".", ".", ".", ".", ".", "."],
        [".", ".", ".", ".", ".", ".", ".", "."],
        ["P", "P", "P", "P", "P", "P", "P", "P"],
        ["R", "N", "B", "Q", "K", "B", "N", "R"],
      ]

      expected_output = <<~BOARD
        8 r n b q k b n r
        7 p p p p p p p p
        6 . . . . . . . .
        5 . . . . . . . .
        4 . . . . . . . .
        3 . . . . . . . .
        2 P P P P P P P P
        1 R N B Q K B N R
          a b c d e f g h
      BOARD

      expect { ui.display(board) }
        .to(output(expected_output).to_stdout)
    end
  end

  describe "#translate_user_input" do
    it "translates a1 to row 7 and column 0" do
      expect(ui.translate_user_input("a1")).to(eq([7, 0]))
    end

    it "translates e4 to row 4 and column 4" do
      expect(ui.translate_user_input("e4")).to(eq([4, 4]))
    end

    it "translates h8 to row 0 and column 7" do
      expect(ui.translate_user_input("h8")).to(eq([0, 7]))
    end
  end

  describe "#translate_castling_computer_input" do
    it "translates two board positions into one chess move" do
      expect(ui.translate_castling_computer_input([7, 4, 7, 2]))
        .to(eq("e1c1"))
    end

    it "translates kingside castling coordinates" do
      expect(ui.translate_castling_computer_input([7, 4, 7, 6]))
        .to(eq("e1g1"))
    end
  end

  describe "#translate_computer_input" do
    it "translates board coordinates into chess notation" do
      expect(ui.translate_computer_input([7, 0])).to(eq("a1"))
      expect(ui.translate_computer_input([4, 4])).to(eq("e4"))
      expect(ui.translate_computer_input([0, 7])).to(eq("h8"))
    end

    it "translates four coordinates as a castling move" do
      expect(ui.translate_computer_input([7, 4, 7, 2]))
        .to(eq("e1c1"))
    end
  end

  describe "#create_useable_array" do
    let(:column_map) do
      {
        "a" => 0,
        "b" => 1,
        "c" => 2,
        "d" => 3,
        "e" => 4,
        "f" => 5,
        "g" => 6,
        "h" => 7,
      }
    end

    let(:row_map) do
      {
        "1" => 7,
        "2" => 6,
        "3" => 5,
        "4" => 4,
        "5" => 3,
        "6" => 2,
        "7" => 1,
        "8" => 0,
      }
    end

    it "creates a usable board coordinate array" do
      expect(
        ui.create_useable_array("c5", column_map, row_map),
      ).to(eq([3, 2]))
    end
  end

  describe "#translate_castling_input" do
    it "translates queenside castling input" do
      expect(ui.translate_castling_input("e1c1"))
        .to(eq([[7, 4], [7, 2]]))
    end

    it "translates kingside castling input" do
      expect(ui.translate_castling_input("e1g1"))
        .to(eq([[7, 4], [7, 6]]))
    end

    it "translates castling on the eighth rank" do
      expect(ui.translate_castling_input("e8c8"))
        .to(eq([[0, 4], [0, 2]]))
    end
  end
end
