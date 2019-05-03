use Mix.Config

config :logger, level: :error

config :httpc_bench,
  iterations: 20480,
  concurrencies: [32, 64, 128, 256, 512, 1024, 2048, 4096],
  pool_sizes: [8, 16, 32, 128, 256],
  pool_counts: [1, 2, 4, 8, 16, 32],
  clients: [
    HttpcBench.Client.Buoy,
    HttpcBench.Client.Dlhttpc,
    HttpcBench.Client.Hackney,
    # HttpcBench.Client.Httpc,
    # HttpcBench.Client.Ibrowse,
    # HttpcBench.Client.Gun,
    HttpcBench.Client.Mojito,
  ],
  url: System.get_env("URL") || "http://127.0.0.1:8080/",
  hostname: System.get_env("HOSTNAME") || "127.0.0.1",
  port: (System.get_env("PORT") || "8080") |> String.to_integer(),
  path: "/",
  pipelining: 1024,
  timeout: 1000,
  headers: [{"connection", "keep-alive"}]

import_config "#{Mix.env()}*.exs"
