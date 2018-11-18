defmodule LadyGaga.Hands.FullHouse do
  alias LadyGaga.{Reader, HandsCommon}

  @behaviour LadyGaga.Hand

  def read_hand(cards) do
    with {_, _, _, _} = three <- HandsCommon.find_three(cards),
         remaining <- HandsCommon.remove_excess(three, cards),
         {_, _, _} <- HandsCommon.find_pair(remaining) do
      {rate, c1, _, _} = three
      card_name = Reader.card_name(c1)
      hand_info = {rate, card_name}
      message = "full house: #{card_name}"
      {message, hand_info}
    end
  end

  def process_tie({wrate, wn}, {brate, _bn}) when wrate > brate do
    message = "full house: #{wn}"
    {:white, message}
  end

  def process_tie({wrate, _wn}, {brate, bn}) when wrate < brate do
    message = "full house: #{bn}"
    {:black, message}
  end
end
