# LadyGaga

## Installation

Just clone this repo, and do magic

```bash
mix deps.get && iex -S mix
```
And after that, do something like this
```
  iex(2)> LadyGaga.read_my_poker_face(["6C", "7C", "TC", "9C" , "8C"], ["9D", "tD", "jD", "qD", "kd"])
  {:black_wins, "straight flush - high card: King"}

  iex(3)> LadyGaga.read_my_poker_face(["6C", "7C", "TC", "9C" , "8C"], ["9D", "tD", "jH", "qs", "kC"])
  {:white_wins, "straight flush"}
```