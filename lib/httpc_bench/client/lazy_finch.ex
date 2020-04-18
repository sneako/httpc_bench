defmodule HttpcBench.Client.LazyFinch do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  require Logger

  @pool_timeout 50

  def get do
    try do
      with {:ok, _} <-
             Finch.request(MyFinch, :get, Config.url(), Config.headers(), nil,
               receive_timeout: Config.timeout(),
               pool_timeout: @pool_timeout
             ) do
        :ok
      else
        error ->
          # IO.inspect(error, label: :error)
          error
      end
    catch
      _, _error ->
        # IO.inspect(error, label: :exit)
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
               pool_timeout: @pool_timeout
             ) do
        :ok
      else
        error ->
          # IO.inspect(error)
          error
      end
    catch
      _, _error ->
        # IO.inspect(error, label: :exit)
        {:error, :pool_timeout}
    end
  end

  def start(pool_size, pool_count) do
    shp = shp(Config.url())

    {:ok, _pid} =
      Finch.start_link(
        name: MyFinch,
        pools: %{shp => [size: pool_size, count: pool_count, type: :lazy]}
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
