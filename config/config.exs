use Mix.Config

config :logger, level: :error

config :httpc_bench,
  # one of: [:text, :html, :csv]
  output: :csv,
  iterations: 500_000,
  concurrencies: [16384, 8192, 4096, 2048, 1024, 512, 256],
  pool_sizes: [512, 256, 128, 64, 32],
  pool_counts: [32, 16, 8, 4, 1],
  clients: [
    # HttpcBench.Client.Mojito,
    # HttpcBench.Client.MachineGun,
    # HttpcBench.Client.Buoy,
    HttpcBench.Client.Finch,
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
  test_function: System.get_env("TEST_FUNCTION", "get") |> String.downcase() |> String.to_atom(),
  pipelining: 1024,
  timeout: 15_000,
  headers: [{"connection", "keep-alive"}]

import_config "#{Mix.env()}*.exs"
