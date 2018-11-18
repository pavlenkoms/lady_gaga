defmodule LadyGaga.Hands.Pair do
  alias LadyGaga.{Reader, HandsCommon}

  @behaviour LadyGaga.Hand

  def read_hand(cards) do
    case HandsCommon.find_pair(cards) do
      nil ->
        nil

      {rate, c1, _c2} = pair ->
        remaining = HandsCommon.remove_excess(pair, cards)
        card_name = Reader.card_name(c1)
        hand_info = {rate, card_name, remaining}
        message = "pair: #{card_name}"
        {message, hand_info}
    end
  end

  def process_tie({wrate, _wv, wsr}, {brate, _bv, bsr}) when wrate == brate do
    HandsCommon.check_high_card(wsr, bsr, "pair - high card")
  end

  def process_tie({wrate, wn, _wsr}, {brate, _bn, _bsr}) when wrate > brate do
    message = "pair - high pair: #{wn}"
    {:white, message}
  end

  def process_tie({wrate, _wn, _wsr}, {brate, bn, _bsr}) when wrate < brate do
    message = "pair - high pair: #{bn}"
    {:black, message}
  end
end
