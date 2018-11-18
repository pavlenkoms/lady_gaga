defmodule LadyGaga.Reader do
  alias LadyGaga.Hand

  @type card() :: %{suit: String.t(), value: String.t()}

  @card_info %{
    "2" => {1, "2"},
    "3" => {2, "3"},
    "4" => {3, "4"},
    "5" => {4, "5"},
    "6" => {5, "6"},
    "7" => {6, "7"},
    "8" => {7, "8"},
    "9" => {8, "9"},
    "t" => {9, "10"},
    "j" => {10, "Jack"},
    "q" => {11, "Queen"},
    "k" => {12, "King"},
    "a" => {13, "Ace"}
  }

  def read([_ | _] = white, [_ | _] = black) when length(white) == 5 and length(black) == 5 do
    with [_ | _] = white <- validate_and_convert_cards(white),
         [_ | _] = black <- validate_and_convert_cards(black),
         :ok <- no_duplicates(white, black),
         {:ok, white_hand} <- read_cards(white),
         {:ok, black_hand} <- read_cards(black) do
      compare_hands(white_hand, black_hand)
    else
      {:error, _} = error ->
        error

      _ = error ->
        {:error, {:unknown_error, error}}
    end
  end

  def read(_white, _black) do
    {:error, :bad_cards_length_or_datatype}
  end

  def card_rate(card) do
    {rate, _} = @card_info[card.value]
    rate
  end

  def card_name(card) do
    {_, name} = @card_info[card.value]
    name
  end

  defp validate_and_convert_cards(cards) do
    Enum.reduce_while(cards, [], fn card, acc ->
      with {:ok, card} <- process_card(card) do
        {:cont, [card | acc]}
      else
        {:error, _} = error ->
          {:halt, error}

        _ = error ->
          {:error, {:unknown_error, error}}
      end
    end)
  end

  defp process_card(card) when is_bitstring(card) do
    card = card |> String.downcase()

    ~r/^(?<value>(2|3|4|5|6|7|8|9|t|j|q|k|a){1})(?<suit>(c|d|h|s){1})$/
    |> Regex.named_captures(card)
    |> case do
      %{} = card ->
        {:ok, %{suit: card["suit"], value: card["value"]}}

      nil ->
        {:error, {:bad_card, card}}
    end
  end

  defp process_card(card) do
    {:error, {:bad_card, card}}
  end

  defp read_cards(cards) do
    hands_list = Application.get_env(:lady_gaga, __MODULE__, [])[:hands]

    hands =
      [hands_list, 1..length(hands_list)]
      |> Enum.zip()
      |> Enum.reduce([], fn {hand, rate}, acc ->
        case Hand.read_hand(cards, hand) do
          nil ->
            acc

          result ->
            [{result, rate} | acc]
        end
      end)

    {:ok, hands}
  end

  defp compare_hands([], []) do
    :tie
  end

  defp compare_hands([{result, _} | _], []) do
    {:white_wins, Hand.message(result)}
  end

  defp compare_hands([], [{result, _} | _]) do
    {:black_wins, Hand.message(result)}
  end

  defp compare_hands([{wres, wrate} | _], [{bres, brate} | _]) do
    cond do
      wrate > brate ->
        {:white_wins, Hand.message(wres)}

      brate > wrate ->
        {:black_wins, Hand.message(bres)}

      true ->
        process_tie(wres, bres)
    end
  end

  defp process_tie(white, black) do
    case Hand.process_tie(white, black) do
      {:white, message} ->
        {:white_wins, message}

      {:black, message} ->
        {:black_wins, message}

      :tie ->
        :tie
    end
  end

  defp no_duplicates(white, black) do
    case white -- black do
      ^white ->
        :ok

      less ->
        {:error, {:duplicated_cards, white -- less}}
    end
  end
end
