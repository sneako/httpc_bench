defmodule HttpcBench.Client.Finch do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  require Logger

  def get do
    with {:ok, _} <-
           Finch.request(MyFinch, :get, Config.url(), Config.headers(), "",
             timeout: Config.timeout()
           ) do
      :ok
    end
  end

  def post do
    with {:ok, _} <-
           Finch.request(MyFinch, :post, Config.url(), Config.post_headers(), Config.post_body(),
             timeout: Config.timeout()
           ) do
      :ok
    end
  end

  def start(pool_size, pool_count) do
    shp = shp(Config.url())

    {:ok, _pid} =
      Finch.start_link(name: MyFinch, pools: %{shp => %{size: pool_size, count: pool_count}})

    :ok
  end

  def stop do
    Supervisor.stop(MyFinch.Supervisor)

    :ok
  end

  def shp(url) do
    uri = URI.parse(url)

    {String.to_atom(uri.scheme), uri.host, uri.port}
  end
end
