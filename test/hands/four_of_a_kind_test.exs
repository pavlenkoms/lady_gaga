defmodule LadyGaga.FourOfAKindTest do
  use ExUnit.Case, async: false

  alias LadyGaga.Hands.FourOfAKind

  test "normal" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {13, %{suit: "d", value: "a"}},
      {13, %{suit: "h", value: "a"}},
      {13, %{suit: "s", value: "a"}},
      {5, %{suit: "c", value: "6"}}
    ]

    assert {"four of a kind: Ace", {13, "Ace"}} == FourOfAKind.read_hand(cards)
  end

  test "fail" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {13, %{suit: "d", value: "a"}},
      {13, %{suit: "h", value: "a"}},
      {12, %{suit: "s", value: "k"}},
      {5, %{suit: "c", value: "6"}}
    ]

    assert nil == FourOfAKind.read_hand(cards)
  end

  test "tie white wins" do
    white_info = {13, "Ace"}

    black_info = {12, "King"}

    assert {:white, "four of a kind: Ace"} == FourOfAKind.process_tie(white_info, black_info)
  end

  test "tie black wins" do
    white_info = {12, "King"}

    black_info = {13, "Ace"}

    assert {:black, "four of a kind: Ace"} = FourOfAKind.process_tie(white_info, black_info)
  end
end
