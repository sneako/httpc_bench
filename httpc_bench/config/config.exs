use Mix.Config

config :logger, level: :error

config :httpc_bench,
  iterations: 204800,
  concurrencies: [32, 128, 512, 2048, 8192],
  pool_sizes: [32, 64, 128, 256],
  pool_counts: [1, 4, 16],
  clients: [
    HttpcBench.Client.Buoy,
    HttpcBench.Client.Dlhttpc,
    HttpcBench.Client.Hackney,
    HttpcBench.Client.Mojito,
    # HttpcBench.Client.Httpc,
    # HttpcBench.Client.Ibrowse,
    # HttpcBench.Client.Gun,
  ],
  url: System.get_env("URL") || "http://127.0.0.1:8080/wait/10",
  hostname: System.get_env("HOSTNAME") || "127.0.0.1",
  port: (System.get_env("PORT") || "8080") |> String.to_integer(),
  path: "/wait/10",
  pipelining: 1024,
  timeout: 1000,
  headers: [{"connection", "keep-alive"}]

import_config "#{Mix.env()}*.exs"
