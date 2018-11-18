defmodule LadyGaga.ThreeOfAKindTest do
  use ExUnit.Case, async: false

  alias LadyGaga.Hands.ThreeOfAKind

  test "normal" do
    cards = [
      {11, %{suit: "s", value: "q"}},
      {11, %{suit: "d", value: "q"}},
      {11, %{suit: "c", value: "q"}},
      {8, %{suit: "s", value: "9"}},
      {5, %{suit: "h", value: "6"}}
    ]

    assert {"three of a kind: Queen", {11, "Queen"}} == ThreeOfAKind.read_hand(cards)
  end

  test "fail" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {12, %{suit: "s", value: "k"}},
      {9, %{suit: "d", value: "t"}},
      {8, %{suit: "c", value: "9"}},
      {5, %{suit: "h", value: "6"}}
    ]

    assert nil == ThreeOfAKind.read_hand(cards)
  end

  test "tie white wins" do
    white_info = {13, "Ace"}

    black_info = {12, "King"}

    assert {:white, "three of a kind - high card: Ace"} ==
             ThreeOfAKind.process_tie(white_info, black_info)
  end

  test "tie black wins" do
    white_info = {12, "King"}

    black_info = {13, "Ace"}

    assert {:black, "three of a kind - high card: Ace"} =
             ThreeOfAKind.process_tie(white_info, black_info)
  end
end
