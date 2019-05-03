use Mix.Config

config :httpc_bench,
  iterations: 10000,
  concurrencies: [32],
  pool_sizes: [8],
  pool_counts: [1, 2]
