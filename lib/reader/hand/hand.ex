defmodule LadyGaga.Hand do
  alias LadyGaga.Reader

  @type result() :: %{module: atom(), message: String.t(), hand_info: any()}

  @callback read_hand(hand :: [Reader.card()]) :: result() | nil

  @callback process_tie(white :: any(), black :: any()) ::
              {:white | :black, message :: String.t()} | :tie

  def read_hand(cards, hand) when is_list(cards) do
    if __MODULE__ in (hand.module_info[:attributes][:behaviour] || []) do
      cards = LadyGaga.HandsCommon.sorted_rated(cards)

      with {message, hand_info} <- apply(hand, :read_hand, [cards]) do
        %{
          module: hand,
          message: message,
          hand_info: hand_info
        }
      end
    else
      {:error, {:bad_hand_module, hand}}
    end
  end

  def process_tie(
        %{module: module, hand_info: whi},
        %{module: module, hand_info: bhi}
      )
      when module != nil do
    if __MODULE__ in (module.module_info[:attributes][:behaviour] || []) do
      apply(module, :process_tie, [whi, bhi])
    else
      {:error, {:bad_hand_module, module}}
    end
  end

  def process_tie(
        %{module: module1},
        %{module: module2}
      ) do
    {:error, {:bad_modules_in_tie, {module1, module2}}}
  end

  def message(result) do
    result[:message]
  end
end
