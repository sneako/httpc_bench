defmodule HttpcBench.Router do
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

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Config.bid_response())
  end
end
