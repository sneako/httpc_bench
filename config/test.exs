use Mix.Config

config :httpc_bench,
  iterations: 10000,
  concurrencies: [512],
  pool_sizes: [32, 1],
  pool_counts: [2, 1]
