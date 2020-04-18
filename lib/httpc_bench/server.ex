defmodule HttpcBench.Server do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: HttpcBench.Server.PlugRouter,
        # options: [port: HttpcBench.Config.port()]
        options: [port: HttpcBench.Config.port(), protocol_options: [max_keepalive: :infinity]]
        # options: [port: HttpcBench.Config.port(), protocol_options: [max_keepalive: 1]]
      )
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end

  def stop do
    Supervisor.stop(__MODULE__)
  end
end

defmodule HttpcBench.Server.PlugRouter do
  use Plug.Router
  alias HttpcBench.Config

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

  post "/wait/:delay" do
    delay = String.to_integer(delay)
    Process.sleep(delay)

    # if :rand.uniform() > 0.1 do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Config.bid_response())

    # else
    #   send_resp(conn, 204, "")
    # end
  end
end
