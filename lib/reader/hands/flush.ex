defmodule LadyGaga.Hands.Flush do
  alias LadyGaga.{HandsCommon}

  @behaviour LadyGaga.Hand

  def read_hand(cards) do
    case HandsCommon.find_flush(cards) do
      nil ->
        nil

      {:ok, _} ->
        hand_info = cards
        message = "flush"
        {message, hand_info}
    end
  end

  def process_tie([_ | _] = white, [_ | _] = black) do
    HandsCommon.check_high_card(white, black, "flush - high card")
  end
end
