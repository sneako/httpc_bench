use Mix.Config

config :httpc_bench,
  iterations: 10_000,
  concurrencies: [2048],
  pool_sizes: [20, 50, 100],
  pool_counts: [4, 8, 16]
