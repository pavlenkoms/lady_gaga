defmodule LadyGaga.HighCardTest do
  use ExUnit.Case, async: false

  alias LadyGaga.Hands.HighCard

  test "normal" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {11, %{suit: "d", value: "q"}},
      {9, %{suit: "h", value: "t"}},
      {8, %{suit: "c", value: "9"}},
      {5, %{suit: "s", value: "6"}}
    ]

    assert {"high card: Ace", cards} == HighCard.read_hand(cards)
  end

  test "tie white wins" do
    white_cards = [
      {13, %{suit: "d", value: "a"}},
      {12, %{suit: "h", value: "k"}},
      {9, %{suit: "s", value: "t"}},
      {8, %{suit: "c", value: "9"}},
      {5, %{suit: "d", value: "6"}}
    ]

    black_cards = [
      {13, %{suit: "h", value: "a"}},
      {11, %{suit: "d", value: "q"}},
      {9, %{suit: "c", value: "t"}},
      {8, %{suit: "h", value: "9"}},
      {5, %{suit: "d", value: "6"}}
    ]

    assert {:white, "high card: King"} = HighCard.process_tie(white_cards, black_cards)
  end

  test "tie black wins" do
    white_cards = [
      {13, %{suit: "h", value: "a"}},
      {11, %{suit: "c", value: "q"}},
      {9, %{suit: "d", value: "t"}},
      {8, %{suit: "c", value: "9"}},
      {5, %{suit: "d", value: "6"}}
    ]

    black_cards = [
      {13, %{suit: "c", value: "a"}},
      {12, %{suit: "d", value: "k"}},
      {9, %{suit: "c", value: "t"}},
      {8, %{suit: "h", value: "9"}},
      {5, %{suit: "s", value: "6"}}
    ]

    assert {:black, "high card: King"} = HighCard.process_tie(white_cards, black_cards)
  end

  test "tie" do
    white_cards = [
      {13, %{suit: "c", value: "a"}},
      {12, %{suit: "d", value: "k"}},
      {9, %{suit: "h", value: "t"}},
      {8, %{suit: "s", value: "9"}},
      {5, %{suit: "c", value: "6"}}
    ]

    assert :tie = HighCard.process_tie(white_cards, white_cards)
  end
end
