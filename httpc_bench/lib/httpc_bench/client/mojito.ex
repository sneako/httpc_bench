defmodule HttpcBench.Client.Mojito do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  def get do
    {:ok, _} = Mojito.Pool.request(%Mojito.Request{method: :get, url: Config.url(), headers: Config.headers()})
    :ok
  end

  def start(pool_size, pool_count) do
    Application.put_env(:mojito, :pool_opts, [size: pool_size, max_overflow: 0, max_pools: pool_count])
    {:ok, _} = :application.ensure_all_started(:mojito)
    :ok
  end

  def stop do
    :ok = :application.stop(:mojito)
  end
end
