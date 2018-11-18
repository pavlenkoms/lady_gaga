defmodule LadyGaga.FlushTest do
  use ExUnit.Case, async: false

  alias LadyGaga.Hands.Flush

  test "normal" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {11, %{suit: "c", value: "q"}},
      {9, %{suit: "c", value: "t"}},
      {8, %{suit: "c", value: "9"}},
      {5, %{suit: "c", value: "6"}}
    ]

    assert {"flush", cards} == Flush.read_hand(cards)
  end

  test "fail" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {12, %{suit: "c", value: "k"}},
      {9, %{suit: "d", value: "t"}},
      {8, %{suit: "c", value: "9"}},
      {5, %{suit: "c", value: "6"}}
    ]

    assert nil == Flush.read_hand(cards)
  end

  test "tie white wins" do
    white_cards = [
      {13, %{suit: "c", value: "a"}},
      {12, %{suit: "c", value: "k"}},
      {9, %{suit: "c", value: "t"}},
      {8, %{suit: "c", value: "9"}},
      {5, %{suit: "c", value: "6"}}
    ]

    black_cards = [
      {13, %{suit: "c", value: "a"}},
      {11, %{suit: "c", value: "q"}},
      {9, %{suit: "c", value: "t"}},
      {8, %{suit: "c", value: "9"}},
      {5, %{suit: "c", value: "6"}}
    ]

    assert {:white, "flush - high card: King"} = Flush.process_tie(white_cards, black_cards)
  end

  test "tie black wins" do
    white_cards = [
      {13, %{suit: "c", value: "a"}},
      {11, %{suit: "c", value: "q"}},
      {9, %{suit: "c", value: "t"}},
      {8, %{suit: "c", value: "9"}},
      {5, %{suit: "c", value: "6"}}
    ]

    black_cards = [
      {13, %{suit: "c", value: "a"}},
      {12, %{suit: "c", value: "k"}},
      {9, %{suit: "c", value: "t"}},
      {8, %{suit: "c", value: "9"}},
      {5, %{suit: "c", value: "6"}}
    ]

    assert {:black, "flush - high card: King"} = Flush.process_tie(white_cards, black_cards)
  end

  test "tie" do
    white_cards = [
      {13, %{suit: "c", value: "a"}},
      {12, %{suit: "c", value: "k"}},
      {9, %{suit: "c", value: "t"}},
      {8, %{suit: "c", value: "9"}},
      {5, %{suit: "c", value: "6"}}
    ]

    assert :tie = Flush.process_tie(white_cards, white_cards)
  end
end
