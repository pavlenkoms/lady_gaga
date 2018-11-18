defmodule LadyGaga.Hands.HighCard do
  alias LadyGaga.{HandsCommon, Reader}

  @behaviour LadyGaga.Hand

  def read_hand(cards) do
    [{_, high_card} | _] = cards
    message = "high card: #{Reader.card_name(high_card)}"
    {message, cards}
  end

  def process_tie([_ | _] = white, [_ | _] = black) do
    HandsCommon.check_high_card(white, black, "high card")
  end
end
