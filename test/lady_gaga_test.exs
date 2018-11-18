defmodule LadyGagaTest do
  use ExUnit.Case, async: false

  @white_cards ["2C", "3D", "TH", "KS", "AC"]
  @black_cards ["4H", "5S", "6C", "JC", "QD"]

  test "mamamamamama poker face" do
    Application.put_env(:lady_gaga, LadyGaga.Reader, hands: [LadyGaga.Hands.HighCard])

    assert LadyGaga.read_my_poker_face(@white_cards, @black_cards) ==
             {:white_wins, "high card: Ace"}
  end
end
