defmodule LadyGaga.StraightTest do
  use ExUnit.Case, async: false

  alias LadyGaga.Hands.Straight

  test "normal" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {12, %{suit: "d", value: "k"}},
      {11, %{suit: "h", value: "q"}},
      {10, %{suit: "s", value: "j"}},
      {9, %{suit: "c", value: "t"}}
    ]

    assert {"straight", {13, "Ace"}} == Straight.read_hand(cards)
  end

  test "fail" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {12, %{suit: "d", value: "k"}},
      {11, %{suit: "h", value: "q"}},
      {10, %{suit: "s", value: "j"}},
      {8, %{suit: "c", value: "9"}}
    ]

    assert nil == Straight.read_hand(cards)
  end

  test "tie white wins" do
    white_info = {13, "Ace"}

    black_info = {12, "King"}

    assert {:white, "straight - high card: Ace"} = Straight.process_tie(white_info, black_info)
  end

  test "tie black wins" do
    white_info = {12, "King"}

    black_info = {13, "Ace"}

    assert {:black, "straight - high card: Ace"} = Straight.process_tie(white_info, black_info)
  end

  test "tie" do
    white_info = {13, "Ace"}

    assert :tie = Straight.process_tie(white_info, white_info)
  end
end
