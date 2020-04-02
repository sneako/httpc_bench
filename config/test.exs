use Mix.Config

config :httpc_bench,
  iterations: 10_000,
  concurrencies: [512, 256],
  pool_sizes: [128, 96, 64, 32],
  pool_counts: [32, 24, 16, 8]

#
# config :httpc_bench,
#   iterations: 10_000,
#   # concurrencies: [256, 512],
#   concurrencies: [100, 64, 128, 256, 512],
#   pool_sizes: [20, 50, 100, 150, 256, 512],
#   pool_counts: [8, 16, 32, 64]

# config :httpc_bench,
#   iterations: 10_000,
#   concurrencies: [128, 256, 512, 1024],
#   pool_sizes: [50, 100, 150],
#   pool_counts: [4, 8, 16]

# concurrencies: [256, 512, 1024],
# pool_sizes: [20, 50, 100],
# pool_counts: [4, 8, 16]
