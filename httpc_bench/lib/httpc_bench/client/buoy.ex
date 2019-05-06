defmodule HttpcBench.Client.Buoy do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  def get do
    case :buoy.get(Config.buoy_url(), %{timeout: Config.timeout()}) do
      {:ok, _} -> :ok
      error -> error
    end
  end

  def start(pool_size, pool_count) do
    cond do
      pool_size == 0 ->
        {:error, "skipping pool size 1"}

      pool_count > 1 ->
        {:error, "multiple pools not supported"}

      :else ->
        {:ok, _} = :buoy_app.start()

        :ok =
          :buoy_pool.start(
            Config.buoy_url(),
            backlog_size: Config.pipelining(),
            pool_size: pool_size
          )
    end
  end

  def stop do
    :ok = :buoy_pool.stop(Config.buoy_url())
  end
end
