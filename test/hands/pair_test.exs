defmodule LadyGaga.PairTest do
  use ExUnit.Case, async: false

  alias LadyGaga.Hands.Pair

  test "normal" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {11, %{suit: "d", value: "q"}},
      {11, %{suit: "c", value: "q"}},
      {8, %{suit: "s", value: "9"}},
      {5, %{suit: "h", value: "6"}}
    ]

    rem = [
      {13, %{suit: "c", value: "a"}},
      {8, %{suit: "s", value: "9"}},
      {5, %{suit: "h", value: "6"}}
    ]

    assert {"pair: Queen", {11, "Queen", rem}} == Pair.read_hand(cards)
  end

  test "fail" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {12, %{suit: "s", value: "k"}},
      {9, %{suit: "d", value: "t"}},
      {8, %{suit: "c", value: "9"}},
      {5, %{suit: "h", value: "6"}}
    ]

    assert nil == Pair.read_hand(cards)
  end

  test "tie white wins high pair" do
    white_info =
      {11, "Queen",
       [
         {13, %{suit: "c", value: "a"}},
         {8, %{suit: "s", value: "9"}},
         {5, %{suit: "h", value: "6"}}
       ]}

    black_info =
      {9, "10",
       [
         {13, %{suit: "d", value: "a"}},
         {11, %{suit: "h", value: "q"}},
         {5, %{suit: "s", value: "6"}}
       ]}

    assert {:white, "pair - high pair: Queen"} = Pair.process_tie(white_info, black_info)
  end

  test "tie black wins high pair" do
    white_info =
      {11, "Queen",
       [
         {13, %{suit: "c", value: "a"}},
         {8, %{suit: "s", value: "9"}},
         {5, %{suit: "h", value: "6"}}
       ]}

    black_info =
      {9, "10",
       [
         {13, %{suit: "d", value: "a"}},
         {11, %{suit: "h", value: "q"}},
         {5, %{suit: "s", value: "6"}}
       ]}

    assert {:black, "pair - high pair: Queen"} = Pair.process_tie(black_info, white_info)
  end

  test "tie white wins high card" do
    white_info =
      {11, "Queen",
       [
         {13, %{suit: "c", value: "a"}},
         {12, %{suit: "s", value: "k"}},
         {5, %{suit: "h", value: "6"}}
       ]}

    black_info =
      {11, "Queen",
       [
         {13, %{suit: "d", value: "a"}},
         {9, %{suit: "h", value: "t"}},
         {5, %{suit: "s", value: "6"}}
       ]}

    assert {:white, "pair - high card: King"} = Pair.process_tie(white_info, black_info)
  end

  test "tie black wins high card" do
    white_info =
      {11, "Queen",
       [
         {13, %{suit: "d", value: "a"}},
         {9, %{suit: "h", value: "t"}},
         {5, %{suit: "s", value: "6"}}
       ]}

    black_info =
      {11, "Queen",
       [
         {13, %{suit: "c", value: "a"}},
         {12, %{suit: "s", value: "k"}},
         {5, %{suit: "h", value: "6"}}
       ]}

    assert {:black, "pair - high card: King"} = Pair.process_tie(white_info, black_info)
  end

  test "tie" do
    white_info =
      {11, "Queen",
       [
         {13, %{suit: "c", value: "a"}},
         {12, %{suit: "s", value: "k"}},
         {5, %{suit: "h", value: "6"}}
       ]}

    assert :tie = Pair.process_tie(white_info, white_info)
  end
end
