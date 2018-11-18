defmodule LadyGaga.Hands.StraightFlush do
  alias LadyGaga.{Reader, HandsCommon}

  @behaviour LadyGaga.Hand

  def read_hand(cards) do
    with {:ok, _s} <- HandsCommon.find_flush(cards),
         {rate, c1} <- HandsCommon.find_straight(cards) do
      hand_info = {rate, Reader.card_name(c1)}
      message = "straight flush"
      {message, hand_info}
    end
  end

  def process_tie({wr, _}, {br, _}) when wr == br do
    :tie
  end

  def process_tie({wr, wname}, {br, _}) when wr > br do
    message = "straight flush - high card: #{wname}"
    {:white, message}
  end

  def process_tie({wr, _}, {br, bname}) when wr < br do
    message = "straight flush - high card: #{bname}"
    {:black, message}
  end
end
