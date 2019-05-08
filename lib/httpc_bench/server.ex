defmodule HttpcBench.Server do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: HttpcBench.Server.PlugRouter,
        options: [port: HttpcBench.Config.port()]
      ),
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end

defmodule HttpcBench.Server.PlugRouter do
  use Plug.Router

  plug(:match)

  plug(:dispatch)

  get "/" do
    name = conn.params["name"] || "world"
    send_resp(conn, 200, "Hello #{name}!")
  end

  get "/wait/:delay" do
    delay = conn.params["delay"] |> String.to_integer()
    Process.sleep(delay)
    send_resp(conn, 200, "ok")
  end
end
