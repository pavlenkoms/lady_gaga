defmodule LadyGaga.CommonTest do
  use ExUnit.Case, async: false

  alias LadyGaga.HandsCommon

  describe "sorted_rated" do
    test "sort" do
      cards = [
        %{suit: "c", value: "a"},
        %{suit: "c", value: "2"},
        %{suit: "s", value: "k"},
        %{suit: "d", value: "3"},
        %{suit: "h", value: "t"}
      ]

      sorted_rated = [
        {13, %{suit: "c", value: "a"}},
        {12, %{suit: "s", value: "k"}},
        {9, %{suit: "h", value: "t"}},
        {2, %{suit: "d", value: "3"}},
        {1, %{suit: "c", value: "2"}}
      ]

      assert sorted_rated == HandsCommon.sorted_rated(cards)
    end
  end

  describe "check high card" do
    test "check black wins" do
      white_cards = [
        {13, %{suit: "c", value: "a"}},
        {12, %{suit: "s", value: "k"}},
        {9, %{suit: "h", value: "t"}},
        {2, %{suit: "d", value: "3"}},
        {1, %{suit: "c", value: "2"}}
      ]

      black_cards = [
        {13, %{suit: "c", value: "a"}},
        {12, %{suit: "s", value: "k"}},
        {10, %{suit: "h", value: "j"}},
        {4, %{suit: "d", value: "5"}},
        {3, %{suit: "c", value: "4"}}
      ]

      {:black, "prefix: Jack"} = HandsCommon.check_high_card(white_cards, black_cards, "prefix")
    end

    test "check white wins" do
      white_cards = [
        {13, %{suit: "c", value: "a"}},
        {12, %{suit: "s", value: "k"}},
        {9, %{suit: "h", value: "t"}},
        {2, %{suit: "d", value: "3"}},
        {1, %{suit: "c", value: "2"}}
      ]

      black_cards = [
        {13, %{suit: "c", value: "a"}},
        {12, %{suit: "s", value: "k"}},
        {10, %{suit: "h", value: "j"}},
        {4, %{suit: "d", value: "5"}},
        {3, %{suit: "c", value: "4"}}
      ]

      {:white, "prefix: Jack"} = HandsCommon.check_high_card(black_cards, white_cards, "prefix")
    end

    test "check tie" do
      white_cards = [
        {13, %{suit: "c", value: "a"}},
        {12, %{suit: "s", value: "k"}},
        {9, %{suit: "h", value: "t"}},
        {2, %{suit: "d", value: "3"}},
        {1, %{suit: "c", value: "2"}}
      ]

      black_cards = [
        {13, %{suit: "c", value: "a"}},
        {12, %{suit: "s", value: "k"}},
        {9, %{suit: "h", value: "t"}},
        {2, %{suit: "d", value: "3"}},
        {1, %{suit: "c", value: "2"}}
      ]

      :tie = HandsCommon.check_high_card(white_cards, black_cards, "prefix")
    end
  end

  describe "remove excess" do
    test "remove pair" do
      c1 = %{suit: "c", value: "j"}
      c2 = %{suit: "s", value: "j"}

      head_c = {13, %{suit: "h", value: "a"}}

      cards = [
        {2, %{suit: "d", value: "3"}},
        {1, %{suit: "c", value: "2"}}
      ]

      assert [head_c | cards] ==
               HandsCommon.remove_excess({10, c1, c2}, [head_c, {10, c1}, {10, c2} | cards])
    end

    test "remove three" do
      c1 = %{suit: "c", value: "j"}
      c2 = %{suit: "s", value: "j"}
      c3 = %{suit: "d", value: "j"}
      head_c = {13, %{suit: "h", value: "a"}}
      card = {1, %{suit: "c", value: "2"}}

      assert [head_c, card] ==
               HandsCommon.remove_excess({10, c1, c2, c3}, [
                 head_c,
                 {10, c1},
                 {10, c2},
                 {10, c3},
                 card
               ])
    end
  end

  describe "pair" do
    test "find in middle" do
      c1 = %{suit: "h", value: "t"}
      c2 = %{suit: "d", value: "t"}

      cards = [
        {13, %{suit: "c", value: "a"}},
        {12, %{suit: "s", value: "k"}},
        {9, c1},
        {9, c2},
        {1, %{suit: "c", value: "2"}}
      ]

      assert {9, c1, c2} == HandsCommon.find_pair(cards)
    end

    test "find start" do
      c1 = %{suit: "h", value: "t"}
      c2 = %{suit: "d", value: "t"}

      cards = [
        {9, c1},
        {9, c2},
        {4, %{suit: "h", value: "5"}},
        {3, %{suit: "h", value: "4"}},
        {1, %{suit: "c", value: "2"}}
      ]

      assert {9, c1, c2} == HandsCommon.find_pair(cards)
    end

    test "find in three" do
      c1 = %{suit: "h", value: "t"}
      c2 = %{suit: "d", value: "t"}

      cards = [
        {9, c1},
        {9, c2},
        {9, %{suit: "s", value: "t"}},
        {3, %{suit: "h", value: "4"}},
        {1, %{suit: "c", value: "2"}}
      ]

      assert {9, c1, c2} == HandsCommon.find_pair(cards)
    end

    test "find in nonpair" do
      cards = [
        {13, %{suit: "c", value: "a"}},
        {12, %{suit: "s", value: "k"}},
        {9, %{suit: "h", value: "t"}},
        {2, %{suit: "d", value: "3"}},
        {1, %{suit: "c", value: "2"}}
      ]

      assert nil == HandsCommon.find_pair(cards)
    end
  end

  describe "three" do
    test "find in middle" do
      c1 = %{suit: "h", value: "t"}
      c2 = %{suit: "d", value: "t"}
      c3 = %{suit: "s", value: "t"}

      cards = [
        {13, %{suit: "c", value: "a"}},
        {9, c1},
        {9, c2},
        {9, c3},
        {1, %{suit: "c", value: "2"}}
      ]

      assert {9, c1, c2, c3} == HandsCommon.find_three(cards)
    end

    test "find start" do
      c1 = %{suit: "h", value: "t"}
      c2 = %{suit: "d", value: "t"}
      c3 = %{suit: "s", value: "t"}

      cards = [
        {9, c1},
        {9, c2},
        {9, c3},
        {3, %{suit: "h", value: "4"}},
        {1, %{suit: "c", value: "2"}}
      ]

      assert {9, c1, c2, c3} == HandsCommon.find_three(cards)
    end

    test "find in non three" do
      c1 = %{suit: "h", value: "t"}
      c2 = %{suit: "d", value: "t"}

      cards = [
        {9, c1},
        {9, c2},
        {4, %{suit: "h", value: "5"}},
        {3, %{suit: "h", value: "4"}},
        {1, %{suit: "c", value: "2"}}
      ]

      assert nil == HandsCommon.find_three(cards)
    end
  end

  describe "straight" do
    test "normal" do
      c1 = %{suit: "c", value: "a"}

      cards = [
        {13, c1},
        {12, %{suit: "s", value: "k"}},
        {11, %{suit: "h", value: "q"}},
        {10, %{suit: "d", value: "j"}},
        {9, %{suit: "c", value: "t"}}
      ]

      assert {13, c1} == HandsCommon.find_straight(cards)
    end

    test "fail" do
      cards = [
        {13, %{suit: "c", value: "a"}},
        {12, %{suit: "s", value: "k"}},
        {11, %{suit: "h", value: "q"}},
        {10, %{suit: "d", value: "j"}},
        {8, %{suit: "c", value: "9"}}
      ]

      assert nil == HandsCommon.find_straight(cards)
    end
  end

  describe "flush" do
    test "normal" do
      cards = [
        {13, %{suit: "c", value: "a"}},
        {12, %{suit: "c", value: "k"}},
        {9, %{suit: "c", value: "t"}},
        {8, %{suit: "c", value: "9"}},
        {5, %{suit: "c", value: "6"}}
      ]

      assert {:ok, "c"} == HandsCommon.find_flush(cards)
    end

    test "fail" do
      cards = [
        {13, %{suit: "c", value: "a"}},
        {12, %{suit: "c", value: "k"}},
        {9, %{suit: "d", value: "t"}},
        {8, %{suit: "c", value: "9"}},
        {5, %{suit: "c", value: "6"}}
      ]

      assert nil == HandsCommon.find_flush(cards)
    end
  end
end
