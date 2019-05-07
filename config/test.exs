use Mix.Config

config :httpc_bench,
  iterations: 10000,
  concurrencies: [512],
  pool_sizes: [32],
  pool_counts: [1, 2]
