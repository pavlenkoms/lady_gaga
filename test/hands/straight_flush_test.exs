defmodule LadyGaga.StraightFlushTest do
  use ExUnit.Case, async: false

  alias LadyGaga.Hands.StraightFlush

  test "normal" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {12, %{suit: "c", value: "k"}},
      {11, %{suit: "c", value: "q"}},
      {10, %{suit: "c", value: "j"}},
      {9, %{suit: "c", value: "t"}}
    ]

    assert {"straight flush", {13, "Ace"}} == StraightFlush.read_hand(cards)
  end

  test "fail flush" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {12, %{suit: "c", value: "k"}},
      {11, %{suit: "d", value: "q"}},
      {10, %{suit: "c", value: "j"}},
      {9, %{suit: "c", value: "t"}}
    ]

    assert nil == StraightFlush.read_hand(cards)
  end

  test "fail straight" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {12, %{suit: "c", value: "k"}},
      {11, %{suit: "c", value: "q"}},
      {10, %{suit: "c", value: "j"}},
      {8, %{suit: "c", value: "9"}}
    ]

    assert nil == StraightFlush.read_hand(cards)
  end

  test "tie white wins" do
    white_info = {13, "Ace"}

    black_info = {12, "King"}

    assert {:white, "straight flush - high card: Ace"} =
             StraightFlush.process_tie(white_info, black_info)
  end

  test "tie black wins" do
    white_info = {12, "King"}

    black_info = {13, "Ace"}

    assert {:black, "straight flush - high card: Ace"} =
             StraightFlush.process_tie(white_info, black_info)
  end

  test "tie" do
    white_info = {13, "Ace"}

    assert :tie = StraightFlush.process_tie(white_info, white_info)
  end
end
