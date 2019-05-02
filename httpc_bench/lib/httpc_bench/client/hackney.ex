defmodule HttpcBench.Client.Hackney do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  def get do
    {:ok, _, _, ref} =
      :hackney.request(:get, Config.url(), Config.headers(), "", pool: :httpc_bench_hackney)

    {:ok, _} = :hackney.body(ref)
    :ok
  end

  def start(pool_size, pool_count) do
    if pool_count > 1 do
      {:error, "multiple pools not supported"}
    else
      {:ok, _} = :application.ensure_all_started(:hackney)
      opts = [pool_size: pool_size, timeout: HttpcBench.Config.timeout()]
      :ok = :hackney_pool.start_pool(:httpc_bench_hackney, opts)
    end
  end

  def stop do
    :ok = :application.stop(:hackney)
  end
end
