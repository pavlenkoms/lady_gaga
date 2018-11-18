defmodule LadyGaga.Hands.TwoPairs do
  alias LadyGaga.{Reader, HandsCommon}

  @behaviour LadyGaga.Hand

  def read_hand(cards) do
    with {_, _, _} = p1 <- HandsCommon.find_pair(cards),
         remaining <- HandsCommon.remove_excess(p1, cards),
         {_, _, _} = p2 <- HandsCommon.find_pair(remaining),
         remaining <- HandsCommon.remove_excess(p2, remaining) do
      {rate1, c1, _} = p1
      {rate2, c2, _} = p2
      card_name1 = Reader.card_name(c1)
      card_name2 = Reader.card_name(c2)

      hand_info = {[{rate1, card_name1}, {rate2, card_name2}], remaining}
      message = "two pairs: #{card_name1}, #{card_name2}"
      {message, hand_info}
    end
  end

  def process_tie({[], wrem}, {[], brem}) do
    HandsCommon.check_high_card(wrem, brem, "two pairs - high card")
  end

  def process_tie({[{wrate, _wn} | wtail], wrem}, {[{brate, _bn} | btail], brem})
      when wrate == brate do
    process_tie({wtail, wrem}, {btail, brem})
  end

  def process_tie({[{wrate, wname} | _], _}, {[{brate, _bn} | _], _}) when wrate > brate do
    message = "two pairs - high pair: #{wname}"
    {:white, message}
  end

  def process_tie({[{wrate, _wv} | _], _}, {[{brate, bname} | _], _}) when wrate < brate do
    message = "two pairs - high pair: #{bname}"
    {:black, message}
  end
end
