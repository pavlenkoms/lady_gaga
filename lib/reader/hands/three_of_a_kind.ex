defmodule LadyGaga.Hands.ThreeOfAKind do
  alias LadyGaga.{Reader, HandsCommon}

  @behaviour LadyGaga.Hand

  def read_hand(cards) do
    case HandsCommon.find_three(cards) do
      nil ->
        nil

      {rate, c1, _c2, _c3} ->
        card_name = Reader.card_name(c1)
        hand_info = {rate, card_name}
        message = "three of a kind: #{card_name}"
        {message, hand_info}
    end
  end

  def process_tie({wrate, wname}, {brate, _bname}) when wrate > brate do
    message = "three of a kind - high card: #{wname}"
    {:white, message}
  end

  def process_tie({wrate, _wname}, {brate, bname}) when wrate < brate do
    message = "three of a kind - high card: #{bname}"
    {:black, message}
  end
end
