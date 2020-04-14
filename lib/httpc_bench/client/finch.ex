defmodule HttpcBench.Client.Finch do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  require Logger

  def get do
    try do
      with {:ok, _} <-
             Finch.request(MyFinch, :get, Config.url(), Config.headers(), nil,
               receive_timeout: Config.timeout(),
               pool_timeout: 50
             ) do
        :ok
      end
    catch
      _, _ ->
        {:error, :pool_timeout}
    end
  end

  def post do
    try do
      with {:ok, _} <-
             Finch.request(
               MyFinch,
               :post,
               Config.url(),
               Config.post_headers(),
               Config.post_body(),
               receive_timeout: Config.timeout(),
               pool_timeout: 50
             ) do
        :ok
      end
    catch
      _, _ ->
        {:error, :pool_timeout}
    end
  end

  def start(pool_size, pool_count) do
    shp = shp(Config.url())

    {:ok, _pid} =
      Finch.start_link(
        name: MyFinch,
        pools: %{shp => [size: pool_size, count: pool_count, min_ready: pool_size]}
      )

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
