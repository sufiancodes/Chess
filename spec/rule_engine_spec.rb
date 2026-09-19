# frozen_string_literal: true

require_relative "../lib/chess/rule_engine"

RSpec.describe(RuleEngine) do
  subject(:rule_engine) { described_class.new }

  describe "#check_mate?" do
    let(:king) { instance_double("King") }
    let(:board) { instance_double("Board") }

    before do
      allow(MoveCalculator).to(receive(:check?))
      allow(MoveCalculator).to(receive(:possible_moves_from))
      allow(rule_engine).to(receive(:can_escape?))
    end

    it "returns true when the king is in check and cannot escape" do
      allow(MoveCalculator).to(receive(:check?).with(king, board).and_return(true))
      allow(king).to(receive(:row).and_return(0))
      allow(king).to(receive(:col).and_return(4))
      allow(MoveCalculator)
        .to(receive(:possible_moves_from)
        .with([0, 4], board)
        .and_return([]))
      allow(rule_engine).to(receive(:can_escape?).with(king, board).and_return(false))

      expect(rule_engine.check_mate?(king, board)).to(be(true))
    end

    it "returns false when the king is not in check" do
      allow(MoveCalculator).to(receive(:check?).with(king, board).and_return(false))

      expect(rule_engine.check_mate?(king, board)).to(be(false))
    end

    it "returns false when the king has possible moves" do
      allow(MoveCalculator).to(receive(:check?).with(king, board).and_return(true))
      allow(king).to(receive(:row).and_return(0))
      allow(king).to(receive(:col).and_return(4))
      allow(MoveCalculator)
        .to(receive(:possible_moves_from)
        .with([0, 4], board)
        .and_return([[1, 4]]))

      expect(rule_engine.check_mate?(king, board)).to(be(false))
    end

    it "returns false when another move can remove the check" do
      allow(MoveCalculator).to(receive(:check?).with(king, board).and_return(true))
      allow(king).to(receive(:row).and_return(0))
      allow(king).to(receive(:col).and_return(4))
      allow(MoveCalculator)
        .to(receive(:possible_moves_from)
        .with([0, 4], board)
        .and_return([]))
      allow(rule_engine).to(receive(:can_escape?).with(king, board).and_return(true))

      expect(rule_engine.check_mate?(king, board)).to(be(false))
    end
  end

  describe "#valid_moves" do
    let(:king) do
      instance_double(
        "King",
        color: "white",
        row: 0,
        col: 4,
      )
    end

    let(:board) { instance_double("Board") }

    let(:friendly_pawn) do
      instance_double(
        "Pawn",
        row: 1,
        col: 3,
        color: "white",
      )
    end

    let(:friendly_rook) do
      instance_double(
        "Rook",
        row: 2,
        col: 0,
        color: "white",
      )
    end

    before do
      stub_const("King", Class.new)

      allow(king).to(receive(:class).and_return(King))

      allow(board)
        .to(receive(:collect_all_pieces)
        .with("white")
        .and_return([king, friendly_pawn, friendly_rook]))

      allow(MoveCalculator)
        .to(receive(:possible_moves_from)
        .with([1, 3], board)
        .and_return([[2, 3], [3, 3]]))

      allow(MoveCalculator)
        .to(receive(:possible_moves_from)
        .with([2, 0], board)
        .and_return([[2, 1], [2, 2]]))
    end

    it "returns all possible moves for non-king pieces" do
      expect(rule_engine.valid_moves(king, board)).to(eq(
        [
          [2, 3],
          [3, 3],
          [2, 1],
          [2, 2],
        ],
      ))
    end

    it "does not calculate moves for the king" do
      expect(MoveCalculator)
        .not_to(receive(:possible_moves_from)
        .with([0, 4], board))

      rule_engine.valid_moves(king, board)
    end
  end

  describe "#pawn_promotion_possible?" do
    it "returns true for a black pawn on the eighth rank" do
      pawn = instance_double("Pawn", color: "black", row: 7)

      expect(rule_engine.pawn_promotion_possible?(pawn)).to(be(true))
    end

    it "returns true for a white pawn on the first rank" do
      pawn = instance_double("Pawn", color: "white", row: 0)

      expect(rule_engine.pawn_promotion_possible?(pawn)).to(be(true))
    end

    it "returns nil for a black pawn that has not reached the last rank" do
      pawn = instance_double("Pawn", color: "black", row: 6)

      expect(rule_engine.pawn_promotion_possible?(pawn)).to(be_nil)
    end

    it "returns nil for a white pawn that has not reached the last rank" do
      pawn = instance_double("Pawn", color: "white", row: 1)

      expect(rule_engine.pawn_promotion_possible?(pawn)).to(be_nil)
    end
  end
  # TODO: #can_escape?
end
