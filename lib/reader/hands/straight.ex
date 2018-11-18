defmodule LadyGaga.Hands.Straight do
  alias LadyGaga.{Reader, HandsCommon}

  @behaviour LadyGaga.Hand

  def read_hand(cards) do
    case HandsCommon.find_straight(cards) do
      nil ->
        nil

      {rate, c1} ->
        hand_info = {rate, Reader.card_name(c1)}
        message = "straight"
        {message, hand_info}
    end
  end

  def process_tie({wrate, _wn}, {brate, _bn}) when wrate == brate do
    :tie
  end

  def process_tie({wrate, wname}, {brate, _bn}) when wrate > brate do
    message = "straight - high card: #{wname}"
    {:white, message}
  end

  def process_tie({wrate, _wn}, {brate, bname}) when wrate < brate do
    message = "straight - high card: #{bname}"
    {:black, message}
  end
end
