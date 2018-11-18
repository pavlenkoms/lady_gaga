defmodule LadyGaga.TestHand2 do
  # never used directly
  @behaviour LadyGaga.Hand

  def read_hand(cards) do
    {"test_message", {"test_hand_info", cards}}
  end

  def process_tie(:white, nil) do
    {:white, "white"}
  end

  def process_tie(nil, :black) do
    {:black, "black"}
  end
end
