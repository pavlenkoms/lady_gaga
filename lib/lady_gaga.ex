defmodule LadyGaga do
  alias LadyGaga.Reader

  @moduledoc """
  Documentation for LadyGaga.
  """

  @doc """
  Simple poker processor.

  ## Examples

      iex(2)> LadyGaga.read_my_poker_face(["6C", "7C", "TC", "9C" , "8C"], ["9D", "tD", "jD", "qD", "kd"])
      {:black_wins, "straight flush - high card: King"}

      iex(3)> LadyGaga.read_my_poker_face(["6C", "7C", "TC", "9C" , "8C"], ["9D", "tD", "jH", "qs", "kC"])
      {:white_wins, "straight flush"}

  """
  def read_my_poker_face(black, white) do
    Reader.read(black, white)
  end
end
