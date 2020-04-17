use Mix.Config

# config :httpc_bench,
#   iterations: 10_000,
#   concurrencies: [128, 256, 512],
#   pool_sizes: [20, 50, 100],
#   pool_counts: [4, 8, 16]
#
config :httpc_bench,
  iterations: 10_000,
  concurrencies: [256, 512],
  pool_sizes: [20, 50, 100],
  pool_counts: [1, 4, 8, 16]

# config :httpc_bench,
#   iterations: 10_000,
#   concurrencies: [128, 256, 512, 1024],
#   pool_sizes: [50, 100, 150],
#   pool_counts: [4, 8, 16]

# concurrencies: [256, 512, 1024],
# pool_sizes: [20, 50, 100],
# pool_counts: [4, 8, 16]
