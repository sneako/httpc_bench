use Mix.Config

config :logger, level: :info

config :httpc_bench,
  url: System.get_env("URL") || "http://127.0.0.1:8080/",
  host: System.get_env("HOST") || "127.0.0.1",
  port: (System.get_env("PORT") || "8080") |> String.to_integer(),
  path: System.get_env("PATH") || "/",
  pipelining: 1024,
  timeout: 1000,
  headers: [{"connection", "keep-alive"}]
