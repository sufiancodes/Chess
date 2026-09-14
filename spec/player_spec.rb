# frozen_string_literal: true

require_relative "../lib/chess/player"

describe Player do
  let(:player) { Player.new }

  it "it returns first player when turn is zero" do
    player.first_player = "Alex"
    player.second_player = "Bob"
    player.turn = 0
    expect(player.current_player).to(eq("Alex"))
  end
end
