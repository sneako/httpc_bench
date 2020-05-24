defmodule HttpcBench.H2Server do
  @moduledoc false
  require Logger

  @fixtures_dir Path.expand("../../test/fixtures", __DIR__)

  def start do
    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :https,
        plug: HttpcBench.Router,
        options: [
          port: HttpcBench.Config.port(),
          cipher_suite: :strong,
          certfile: Path.join([@fixtures_dir, "selfsigned.pem"]),
          keyfile: Path.join([@fixtures_dir, "selfsigned_key.pem"]),
          otp_app: :httpc_bench,
          protocol_options: [
            idle_timeout: 60_000,
            inactivity_timeout: 60_000,
            max_keepalive: 1_000,
            request_timeout: 10_000,
            shutdown_timeout: 10_000
          ]
        ]
      )
    ]

    Logger.info("starting HTTP/2 server")
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
