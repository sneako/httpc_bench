defmodule HttpcBench.Client.Katipo do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  def get do
    case :katipo.get(:httpc_bench_katipo, Config.url()) do
      {:ok, _} -> :ok
      other -> other
    end
  end

  def start(pool_size, pool_count) do
    cond do
      pool_size == 0 ->
        {:error, "skipping pool size 1"}

      pool_count > 1 ->
        {:error, "multiple pools not supported"}

      :else ->
        {:ok, _} = :application.ensure_all_started(:katipo)

        {:ok, _} =
          :katipo_pool.start(
            :httpc_bench_katipo,
            pool_size,
            pipelining: true,
            max_pipeline_length: Config.pipelining()
          )

        :ok
    end
  end

  def stop do
    :ok = :application.stop(:katipo)
    :ok = :application.stop(:gproc)
  end
end
