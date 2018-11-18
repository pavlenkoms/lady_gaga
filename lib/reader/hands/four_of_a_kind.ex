defmodule LadyGaga.Hands.FourOfAKind do
  alias LadyGaga.{Reader}

  @behaviour LadyGaga.Hand

  def read_hand(cards) do
    case find_four(cards) do
      nil ->
        nil

      {_rate, name} = result ->
        hand_info = result
        message = "four of a kind: #{name}"
        {message, hand_info}
    end
  end

  def process_tie({wrate, wname}, {brate, _bn}) when wrate > brate do
    message = "four of a kind: #{wname}"
    {:white, message}
  end

  def process_tie({wrate, _wn}, {brate, bname}) when wrate < brate do
    message = "four of a kind: #{bname}"
    {:black, message}
  end

  def find_four([]), do: nil

  def find_four([{rate, c1}, {rate, _}, {rate, _}, {rate, _} | _]),
    do: {rate, Reader.card_name(c1)}

  def find_four([_ | tail]), do: find_four(tail)
end
