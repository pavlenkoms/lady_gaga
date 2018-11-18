defmodule LadyGaga.FullHouseTest do
  use ExUnit.Case, async: false

  alias LadyGaga.Hands.FullHouse

  test "normal" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {13, %{suit: "d", value: "a"}},
      {13, %{suit: "h", value: "a"}},
      {5, %{suit: "s", value: "6"}},
      {5, %{suit: "c", value: "6"}}
    ]

    assert {"full house: Ace", {13, "Ace"}} == FullHouse.read_hand(cards)
  end

  test "fail" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {13, %{suit: "d", value: "a"}},
      {13, %{suit: "h", value: "a"}},
      {12, %{suit: "s", value: "k"}},
      {5, %{suit: "c", value: "6"}}
    ]

    assert nil == FullHouse.read_hand(cards)
  end

  test "tie white wins" do
    white_info = {13, "Ace"}

    black_info = {12, "King"}

    assert {:white, "full house: Ace"} == FullHouse.process_tie(white_info, black_info)
  end

  test "tie black wins" do
    white_info = {12, "King"}

    black_info = {13, "Ace"}

    assert {:black, "full house: Ace"} = FullHouse.process_tie(white_info, black_info)
  end
end
