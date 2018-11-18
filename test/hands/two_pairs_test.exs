defmodule LadyGaga.TwoPairsTest do
  use ExUnit.Case, async: false

  alias LadyGaga.Hands.TwoPairs

  test "normal" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {13, %{suit: "d", value: "a"}},
      {12, %{suit: "c", value: "k"}},
      {11, %{suit: "c", value: "q"}},
      {11, %{suit: "s", value: "q"}}
    ]

    rem = [{12, %{suit: "c", value: "k"}}]

    assert {"two pairs: Ace, Queen", {[{13, "Ace"}, {11, "Queen"}], rem}} ==
             TwoPairs.read_hand(cards)
  end

  test "fail" do
    cards = [
      {13, %{suit: "c", value: "a"}},
      {13, %{suit: "d", value: "a"}},
      {11, %{suit: "c", value: "q"}},
      {10, %{suit: "s", value: "j"}},
      {5, %{suit: "h", value: "6"}}
    ]

    assert nil == TwoPairs.read_hand(cards)
  end

  test "tie white wins high pair" do
    white_info = {[{11, "Queen"}, {9, "10"}], [{5, %{suit: "h", value: "6"}}]}

    black_info = {[{9, "10"}, {8, "9"}], [{5, %{suit: "s", value: "6"}}]}

    assert {:white, "two pairs - high pair: Queen"} = TwoPairs.process_tie(white_info, black_info)
  end

  test "tie black wins high pair" do
    white_info = {[{9, "10"}, {8, "9"}], [{5, %{suit: "s", value: "6"}}]}

    black_info = {[{11, "Queen"}, {9, "10"}], [{5, %{suit: "h", value: "6"}}]}

    assert {:black, "two pairs - high pair: Queen"} = TwoPairs.process_tie(white_info, black_info)
  end

  test "tie white wins high second pair" do
    white_info = {[{11, "Queen"}, {9, "10"}], [{5, %{suit: "h", value: "6"}}]}

    black_info = {[{11, "Queen"}, {8, "9"}], [{5, %{suit: "s", value: "6"}}]}

    assert {:white, "two pairs - high pair: 10"} = TwoPairs.process_tie(white_info, black_info)
  end

  test "tie black wins high second pair" do
    white_info = {[{11, "Queen"}, {8, "9"}], [{5, %{suit: "s", value: "6"}}]}

    black_info = {[{11, "Queen"}, {9, "10"}], [{5, %{suit: "h", value: "6"}}]}

    assert {:black, "two pairs - high pair: 10"} = TwoPairs.process_tie(white_info, black_info)
  end

  test "tie white wins high card" do
    white_info = {[{11, "Queen"}, {9, "10"}], [{5, %{suit: "h", value: "6"}}]}

    black_info = {[{11, "Queen"}, {9, "10"}], [{4, %{suit: "s", value: "5"}}]}

    assert {:white, "two pairs - high card: 6"} = TwoPairs.process_tie(white_info, black_info)
  end

  test "tie black wins high card" do
    white_info = {[{11, "Queen"}, {9, "10"}], [{4, %{suit: "s", value: "5"}}]}

    black_info = {[{11, "Queen"}, {9, "10"}], [{5, %{suit: "h", value: "6"}}]}

    assert {:black, "two pairs - high card: 6"} = TwoPairs.process_tie(white_info, black_info)
  end

  test "tie" do
    white_info = {[{11, "Queen"}, {9, "10"}], [{4, %{suit: "s", value: "5"}}]}

    assert :tie = TwoPairs.process_tie(white_info, white_info)
  end
end
