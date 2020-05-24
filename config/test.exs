use Mix.Config

config :httpc_bench,
  iterations: 10_000,
  concurrencies: [512, 256],
  pool_sizes: [128, 96, 64, 32],
  pool_counts: [32, 24, 16, 8]
