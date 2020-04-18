use Mix.Config

config :logger, level: :warn

config :httpc_bench,
  # one of: [:text, :html, :csv]
  output: :csv,
  iterations: 500_000,
  concurrencies: [4096, 3064, 2048, 1024],
  pool_sizes: [256, 192, 128, 96, 64, 32],
  pool_counts: [64, 32, 16, 8, 4],
  clients: [
    HttpcBench.Client.Mojito,
    # HttpcBench.Client.MachineGun,
    # HttpcBench.Client.Buoy,
    HttpcBench.Client.Finch,
    HttpcBench.Client.LazyFinch
    # HttpcBench.Client.Dlhttpc,
    # HttpcBench.Client.Hackney,
    # HttpcBench.Client.Httpc,
    # HttpcBench.Client.Ibrowse
    # HttpcBench.Client.Mint,
  ],
  host: System.get_env("SERVER_HOST") || "localhost",
  port: (System.get_env("SERVER_PORT") || "8080") |> String.to_integer(),
  path: System.get_env("SERVER_PATH") || "/wait/10",
  # "get" or "post"
  # System.get_env("TEST_FUNCTION", "get") |> String.downcase() |> String.to_atom(),
  test_function: :get,
  pipelining: 1024,
  timeout: 500,
  headers: [{"connection", "keep-alive"}]

import_config "#{Mix.env()}*.exs"
