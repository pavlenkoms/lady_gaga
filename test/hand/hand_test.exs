defmodule LadyGaga.HandTest do
  use ExUnit.Case, async: false

  alias LadyGaga.{TestHand1, TestHand2, HandsCommon, BadHand, Hand}

  @cards [
    %{suit: "c", value: "a"},
    %{suit: "s", value: "k"},
    %{suit: "h", value: "t"},
    %{suit: "d", value: "3"},
    %{suit: "c", value: "2"}
  ]

  test "test read_hand" do
    {message, hand_info} = TestHand1.read_hand(HandsCommon.sorted_rated(@cards))

    assert %{module: TestHand1, message: message, hand_info: hand_info} ==
             Hand.read_hand(@cards, TestHand1)
  end

  test "test tie" do
    assert :tie ==
             Hand.process_tie(%{module: TestHand1, hand_info: :white}, %{
               module: TestHand1,
               hand_info: :black
             })
  end

  test "error read_hand from bad module" do
    assert {:error, {:bad_hand_module, BadHand}} == Hand.read_hand(@cards, BadHand)
  end

  test "error tie from different modules" do
    assert {:error, {:bad_modules_in_tie, {TestHand1, TestHand2}}} ==
             Hand.process_tie(%{module: TestHand1, hand_info: :white}, %{
               module: TestHand2,
               hand_info: :black
             })
  end

  test "error tie from bad module" do
    assert {:error, {:bad_hand_module, BadHand}} ==
             Hand.process_tie(%{module: BadHand, hand_info: :white}, %{
               module: BadHand,
               hand_info: :black
             })
  end
end
