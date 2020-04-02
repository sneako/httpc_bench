use Mix.Config

config :logger, level: :error

config :httpc_bench,
  output: :text, # one of: [:text, :html, :csv]
  iterations: 500_000,
  concurrencies: [16384, 8192, 4096, 2048, 1024, 512, 256],
  pool_sizes: [512, 256, 128, 64, 32, 1],
  pool_counts: [32, 16, 8, 4, 1],
  clients: [
    # HttpcBench.Client.Mojito,
    # HttpcBench.Client.MachineGun,
    # HttpcBench.Client.Buoy,
    HttpcBench.Client.Finch,
    # HttpcBench.Client.Dlhttpc,
    # HttpcBench.Client.Hackney,
    # HttpcBench.Client.Httpc,
    # HttpcBench.Client.Ibrowse,
    # HttpcBench.Client.Mint,
  ],
  url: System.get_env("URL") || "http://127.0.0.1:8080/wait/100",
  hostname: System.get_env("HOSTNAME") || "127.0.0.1",
  port: (System.get_env("PORT") || "8080") |> String.to_integer(),
  path: "/wait/10",
  pipelining: 1024,
  timeout: 5_000,
  headers: [{"connection", "keep-alive"}]

import_config "#{Mix.env()}*.exs"
