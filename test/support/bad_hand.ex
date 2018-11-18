defmodule LadyGaga.BadHand do
  def read_hand(cards) do
    {"test_message", {"test_hand_info", cards}}
  end

  def process_tie(:white, nil) do
    {:white, "white"}
  end

  def process_tie(nil, :black) do
    {:black, "black"}
  end

  def process_tie(_, _) do
    :tie
  end
end
