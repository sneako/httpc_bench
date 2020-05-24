defmodule HttpcBench.Server do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: HttpcBench.Router,
        options: [port: HttpcBench.Config.port()]
        # options: [port: HttpcBench.Config.port(), protocol_options: [max_keepalive: :infinity]]
        # options: [port: HttpcBench.Config.port(), protocol_options: [max_keepalive: 1]]
      )
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end

  def stop do
    Supervisor.stop(__MODULE__)
  end
end
