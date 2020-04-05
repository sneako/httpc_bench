defmodule HttpcBench.Client.Finch do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  require Logger

  def get do
    case Finch.request(MyFinch, :get, Config.url(), Config.headers(), "",
           timeout: Config.timeout()
         ) do
      {:ok, _} ->
        :ok

      _error ->
        {:error, :fail}
        # error -> error
    end
  end

  def post do
    case Finch.request(MyFinch, :post, Config.url(), Config.post_headers(), Config.post_body(),
           timeout: Config.timeout()
         ) do
      {:ok, _} ->
        :ok

      _error ->
        {:error, :fail}
        # error -> error
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
