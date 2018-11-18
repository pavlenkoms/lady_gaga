defmodule LadyGaga.ReaderTest do
  use ExUnit.Case, async: false

  alias LadyGaga.{TestHand1, TestHand2, Reader, Hand}

  import Mock

  @white_cards ["2C", "3D", "TH", "KS", "AC"]
  @black_cards ["4H", "5S", "6C", "JC", "QD"]

  @white_cards_converted [
    %{suit: "c", value: "a"},
    %{suit: "s", value: "k"},
    %{suit: "h", value: "t"},
    %{suit: "d", value: "3"},
    %{suit: "c", value: "2"}
  ]

  @black_cards_converted [
    %{suit: "d", value: "q"},
    %{suit: "c", value: "j"},
    %{suit: "c", value: "6"},
    %{suit: "s", value: "5"},
    %{suit: "h", value: "4"}
  ]

  test "test black wins in high hand" do
    read_hand = fn
      cards, TestHand1 = module ->
        if cards == @white_cards_converted do
          %{module: module, message: "white in hand1", hand_info: "white in hand1 info"}
        end

      cards, TestHand2 = module ->
        if cards == @black_cards_converted do
          %{module: module, message: "black in hand2", hand_info: "black in hand2 info"}
        end
    end

    message = fn hand -> hand.message end

    with_mock Hand, read_hand: read_hand, message: message do
      {:black_wins, "black in hand2"} = Reader.read(@white_cards, @black_cards)
    end
  end

  test "test black wins in low hand" do
    read_hand = fn
      cards, TestHand1 = module ->
        if cards == @black_cards_converted do
          %{module: module, message: "black in hand1", hand_info: "black in hand1 info"}
        end

      _, TestHand2 ->
        nil
    end

    message = fn hand -> hand.message end

    with_mock Hand, read_hand: read_hand, message: message do
      {:black_wins, "black in hand1"} = Reader.read(@white_cards, @black_cards)
    end
  end

  test "test white wins in high hand" do
    read_hand = fn
      cards, TestHand1 = module ->
        if cards == @black_cards_converted do
          %{module: module, message: "black in hand1", hand_info: "black in hand1 info"}
        end

      cards, TestHand2 = module ->
        if cards == @white_cards_converted do
          %{module: module, message: "white in hand2", hand_info: "white in hand2 info"}
        end
    end

    message = fn hand -> hand.message end

    with_mock Hand, read_hand: read_hand, message: message do
      {:white_wins, "white in hand2"} = Reader.read(@white_cards, @black_cards)
    end
  end

  test "test white wins in low hand" do
    read_hand = fn
      cards, TestHand1 = module ->
        if cards == @white_cards_converted do
          %{module: module, message: "white in hand1", hand_info: "white in hand1 info"}
        end

      _, TestHand2 ->
        nil
    end

    message = fn hand -> hand.message end

    with_mock Hand, read_hand: read_hand, message: message do
      {:white_wins, "white in hand1"} = Reader.read(@white_cards, @black_cards)
    end
  end

  test "test white wins tie high hand" do
    read_hand = fn
      cards, TestHand1 = module ->
        if cards == @black_cards_converted do
          %{module: module, message: "black in hand1", hand_info: "black in hand1 info"}
        end

      _, TestHand2 ->
        %{module: TestHand2, message: "tie", hand_info: "tie"}
    end

    tie = fn
      %{module: TestHand2}, %{module: TestHand2} ->
        {:white, "white in tie2"}

      hand1, hand2 ->
        refute("unexpected hands! #{inspect({hand1, hand2})}")
    end

    with_mock Hand, read_hand: read_hand, process_tie: tie do
      {:white_wins, "white in tie2"} = Reader.read(@white_cards, @black_cards)
    end
  end

  test "test black wins tie high hand" do
    read_hand = fn
      cards, TestHand1 = module ->
        if cards == @white_cards_converted do
          %{module: module, message: "white in hand1", hand_info: "white in hand1 info"}
        end

      _, TestHand2 ->
        %{module: TestHand2, message: "tie", hand_info: "tie"}
    end

    tie = fn
      %{module: TestHand2}, %{module: TestHand2} ->
        {:black, "black in tie2"}

      hand1, hand2 ->
        refute("unexpected hands! #{inspect({hand1, hand2})}")
    end

    with_mock Hand, read_hand: read_hand, process_tie: tie do
      {:black_wins, "black in tie2"} = Reader.read(@white_cards, @black_cards)
    end
  end

  test "test white wins tie low hand" do
    read_hand = fn
      _cards, TestHand1 = module ->
        %{module: module, message: "tie", hand_info: "tie"}

      _cards, TestHand2 ->
        nil
    end

    tie = fn
      %{module: TestHand1}, %{module: TestHand1} ->
        {:white, "white in tie1"}

      hand1, hand2 ->
        refute("unexpected hands! #{inspect({hand1, hand2})}")
    end

    with_mock Hand, read_hand: read_hand, process_tie: tie do
      {:white_wins, "white in tie1"} = Reader.read(@white_cards, @black_cards)
    end
  end

  test "test black wins tie low hand" do
    read_hand = fn
      _cards, TestHand1 = module ->
        %{module: module, message: "tie", hand_info: "tie"}

      _cards, TestHand2 ->
        nil
    end

    tie = fn
      %{module: TestHand1}, %{module: TestHand1} ->
        {:black, "black in tie1"}

      hand1, hand2 ->
        refute("unexpected hands! #{inspect({hand1, hand2})}")
    end

    with_mock Hand, read_hand: read_hand, process_tie: tie do
      {:black_wins, "black in tie1"} = Reader.read(@white_cards, @black_cards)
    end
  end

  test "test tie low hand" do
    read_hand = fn
      _cards, TestHand1 = module ->
        %{module: module, message: "tie", hand_info: "tie"}

      _cards, TestHand2 ->
        nil
    end

    tie = fn
      %{module: TestHand1}, %{module: TestHand1} ->
        :tie

      hand1, hand2 ->
        refute("unexpected hands! #{inspect({hand1, hand2})}")
    end

    with_mock Hand, read_hand: read_hand, process_tie: tie do
      :tie = Reader.read(@white_cards, @black_cards)
    end
  end

  test "test tie high hand" do
    read_hand = fn
      cards, TestHand1 = module ->
        if cards == @white_cards_converted do
          %{module: module, message: "white in hand1", hand_info: "white in hand1 info"}
        end

      _, TestHand2 = module ->
        %{module: module, message: "tie", hand_info: "tie"}
    end

    tie = fn
      %{module: TestHand2}, %{module: TestHand2} ->
        :tie

      hand1, hand2 ->
        refute("unexpected hands! #{inspect({hand1, hand2})}")
    end

    with_mock Hand, read_hand: read_hand, process_tie: tie do
      :tie = Reader.read(@white_cards, @black_cards)
    end
  end

  test "error bad value input card" do
    cards = ["2C", "3D", "1D", "KS", "AC"]
    {:error, {:bad_card, "1d"}} = Reader.read(cards, @black_cards)
  end

  test "error bad suit input card" do
    cards = ["2C", "3D", "AN", "KS", "AC"]
    {:error, {:bad_card, "an"}} = Reader.read(cards, @black_cards)
  end

  test "error double card" do
    [fc, sc | _] = @white_cards
    [_, _ | black_cards] = @black_cards

    {:error, {:duplicated_cards, doubles}} = Reader.read(@white_cards, black_cards ++ [fc, sc])

    assert doubles |> length() == 2
  end

  test "error bad white card count" do
    [_ | white_cards] = @white_cards
    {:error, :bad_cards_length_or_datatype} = Reader.read(white_cards, @black_cards)
  end

  test "error bad white input" do
    white_cards = %{some: :not_fitted}
    {:error, :bad_cards_length_or_datatype} = Reader.read(white_cards, @black_cards)
  end

  test "error bad black card count" do
    [_ | black_cards] = @black_cards
    {:error, :bad_cards_length_or_datatype} = Reader.read(@white_cards, black_cards)
  end

  test "error bad black input" do
    black_cards = %{some: :not_fitted}
    {:error, :bad_cards_length_or_datatype} = Reader.read(@white_cards, black_cards)
  end
end
