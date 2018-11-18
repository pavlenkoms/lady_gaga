use Mix.Config

config :lady_gaga, LadyGaga.Reader,
  hands: [
    LadyGaga.Hands.HighCard,
    LadyGaga.Hands.Pair,
    LadyGaga.Hands.TwoPairs,
    LadyGaga.Hands.ThreeOfAKind,
    LadyGaga.Hands.Straight,
    LadyGaga.Hands.Flush,
    LadyGaga.Hands.FullHouse,
    LadyGaga.Hands.FourOfAKind,
    LadyGaga.Hands.StraightFlush
  ]
