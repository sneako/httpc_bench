defmodule HttpcBench.Client.Hackney do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  def get do
    with {:ok, _, _, ref} <-
           :hackney.request(:get, Config.url(), Config.headers(), "", pool: :httpc_bench_hackney),
         {:ok, _} <- :hackney.body(ref) do
      :ok
    end
  end

  def post do
    with {:ok, _, _, ref} <-
           :hackney.request(:post, Config.url(), Config.headers(), Config.post_body(),
             pool: :httpc_bench_hackney
           ),
         {:ok, _} <- :hackney.body(ref) do
      :ok
    end
  end

  def start(pool_size, pool_count) do
    cond do
      pool_size == 1 ->
        {:error, "skipping pool size 1"}

      pool_count > 1 ->
        {:error, "multiple pools not supported"}

      :else ->
        {:ok, _} = :application.ensure_all_started(:hackney)
        opts = [pool_size: pool_size, timeout: HttpcBench.Config.timeout()]
        :ok = :hackney_pool.start_pool(:httpc_bench_hackney, opts)
    end
  end

  def stop do
    :ok = :application.stop(:hackney)
  end
end
