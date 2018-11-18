defmodule LadyGaga.HandsCommon do
  alias LadyGaga.Reader

  def sorted_rated(cards) do
    rated = for card <- cards, do: {Reader.card_rate(card), card}
    rated |> List.keysort(0) |> Enum.reverse()
  end

  def check_high_card([], [], _pref) do
    :tie
  end

  def check_high_card([{wr, _} | wtail], [{br, _} | btail], pref) when wr == br do
    check_high_card(wtail, btail, pref)
  end

  def check_high_card([{wr, wcard} | _], [{br, _} | _], pref) when wr > br do
    message = "#{pref}: #{Reader.card_name(wcard)}"
    {:white, message}
  end

  def check_high_card([{wr, _} | _], [{br, bcard} | _], pref) when wr < br do
    message = "#{pref}: #{Reader.card_name(bcard)}"
    {:black, message}
  end

  def remove_excess({_, c1, c2, c3}, list) do
    list
    |> List.keydelete(c1, 1)
    |> List.keydelete(c2, 1)
    |> List.keydelete(c3, 1)
  end

  def remove_excess({_, c1, c2}, list) do
    list
    |> List.keydelete(c1, 1)
    |> List.keydelete(c2, 1)
  end

  def find_pair([]), do: nil
  def find_pair([{rate, c1}, {rate, c2} | _]), do: {rate, c1, c2}
  def find_pair([_ | tail]), do: find_pair(tail)

  def find_three([]), do: nil
  def find_three([{rate, c1}, {rate, c2}, {rate, c3} | _]), do: {rate, c1, c2, c3}
  def find_three([_ | tail]), do: find_three(tail)

  def find_straight([{rate1, c1}, {rate2, _}, {rate3, _}, {rate4, _}, {rate5, _}]) do
    straight =
      rate1 == rate2 + 1 and rate1 == rate3 + 2 and rate1 == rate4 + 3 and rate1 == rate5 + 4

    if straight do
      {rate1, c1}
    end
  end

  def find_flush([
        {_, %{suit: s}},
        {_, %{suit: s}},
        {_, %{suit: s}},
        {_, %{suit: s}},
        {_, %{suit: s}}
      ]),
      do: {:ok, s}

  def find_flush(_), do: nil
end
